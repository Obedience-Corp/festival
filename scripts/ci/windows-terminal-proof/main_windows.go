package main

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"flag"
	"fmt"
	"io"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"syscall"
	"time"

	"github.com/charmbracelet/x/conpty"
	"golang.org/x/sys/windows"
)

type journeyState struct {
	Camp string `json:"camp"`
}

type campEntry struct {
	Name string `json:"name"`
	Path string `json:"path"`
}

type frame struct {
	Event   string `json:"event"`
	Width   int    `json:"width"`
	Height  int    `json:"height"`
	VTBytes int    `json:"vt_bytes"`
	Screen  string `json:"screen"`
}

type terminalProbe struct {
	pty    *conpty.ConPty
	screen *terminalScreen
	chunks chan []byte
	raw    bytes.Buffer
	frames []frame
	width  int
	height int
}

func main() {
	workRoot := flag.String("work-root", "", "isolated Server Core proof directory")
	flag.Parse()
	if *workRoot == "" {
		fmt.Fprintln(os.Stderr, "-work-root is required")
		os.Exit(2)
	}
	if err := run(*workRoot); err != nil {
		fmt.Fprintf(os.Stderr, "Windows installed ConPTY terminal proof: FAIL: %v\n", err)
		os.Exit(1)
	}
	fmt.Println("Windows installed ConPTY terminal proof: PASS")
}

func run(workRoot string) (runErr error) {
	stateData, err := os.ReadFile(filepath.Join(workRoot, "journey-state.json"))
	if err != nil {
		return fmt.Errorf("read beginner journey state: %w", err)
	}
	var state journeyState
	if err := json.Unmarshal(stateData, &state); err != nil {
		return fmt.Errorf("parse beginner journey state: %w", err)
	}
	if state.Camp == "" {
		return errors.New("beginner journey state has no camp path")
	}
	install := filepath.Join(workRoot, "Install Folder [native]")
	campExe := filepath.Join(install, "camp.exe")
	if _, err := os.Stat(campExe); err != nil {
		return fmt.Errorf("candidate camp.exe missing: %w", err)
	}
	home := filepath.Join(workRoot, "journey-home")
	config := map[string]string{
		"HOME":               home,
		"USERPROFILE":        home,
		"XDG_CONFIG_HOME":    filepath.Join(home, "config"),
		"CAMP_REGISTRY_PATH": filepath.Join(home, "registry.json"),
		"FEST_CONFIG_DIR":    filepath.Join(home, "fest-config"),
		"CAMP_MACHINES_PATH": filepath.Join(home, "no-machines.yaml"),
		"CAMP_NO_DEFER":      "1",
		"TERM":               "xterm-256color",
	}
	for name, value := range config {
		if err := os.Setenv(name, value); err != nil {
			return fmt.Errorf("set %s: %w", name, err)
		}
	}
	if err := os.Unsetenv("CAMP_ROOT"); err != nil {
		return fmt.Errorf("unset CAMP_ROOT: %w", err)
	}
	if _, err := os.Stat(config["CAMP_MACHINES_PATH"]); !errors.Is(err, os.ErrNotExist) {
		return fmt.Errorf("expected isolated account with no machines file, stat error: %v", err)
	}

	const initialWidth, initialHeight = 100, 32
	pty, err := conpty.New(initialWidth, initialHeight, 0)
	if err != nil {
		return fmt.Errorf("ConPTY unavailable (required for native terminal proof): %w", err)
	}
	defer pty.Close()
	probe := &terminalProbe{
		pty: pty, screen: newTerminalScreen(initialWidth, initialHeight),
		chunks: make(chan []byte, 64), width: initialWidth, height: initialHeight,
	}
	defer func() {
		probe.record("final")
		if evidenceErr := probe.saveEvidence(workRoot); evidenceErr != nil {
			runErr = errors.Join(runErr, evidenceErr)
		}
	}()
	go probe.readLoop()
	pathOutput := filepath.Join(workRoot, "terminal-selected-path.txt")
	if _, err := os.Stat(pathOutput); !errors.Is(err, os.ErrNotExist) {
		return fmt.Errorf("selection file must start absent, stat error: %v", err)
	}
	args := []string{campExe, "list", "--interactive", "--path-output", pathOutput}
	pid, processHandle, err := pty.Spawn(campExe, args, &syscall.ProcAttr{
		Dir: workRoot, Env: os.Environ(),
	})
	if err != nil {
		return fmt.Errorf("spawn installed camp.exe in ConPTY: %w", err)
	}
	process := windows.Handle(processHandle)
	defer windows.CloseHandle(process)
	finished := false
	defer func() {
		if !finished {
			_ = windows.TerminateProcess(process, 1)
		}
	}()
	fmt.Printf("ConPTY spawned installed camp.exe PID %d\n", pid)

	if err := probe.waitFor("launch", 15*time.Second, func(text string) bool {
		return strings.Contains(text, "Camps") && strings.Contains(text, "native-beginner")
	}); err != nil {
		return err
	}
	probe.record("launch")

	if err := probe.drain(100 * time.Millisecond); err != nil {
		return err
	}
	beforeResize := probe.raw.Len()
	const resizedWidth, resizedHeight = 64, 18
	if err := pty.Resize(resizedWidth, resizedHeight); err != nil {
		return fmt.Errorf("ConPTY resize: %w", err)
	}
	probe.width, probe.height = resizedWidth, resizedHeight
	probe.screen.resize(resizedWidth, resizedHeight)
	if err := probe.waitFor("resize", 12*time.Second, func(text string) bool {
		return probe.raw.Len() > beforeResize && strings.Contains(text, "Camps") &&
			strings.Contains(text, "native-beginner")
	}); err != nil {
		return err
	}
	probe.record("resize")

	if _, err := pty.Write([]byte("r")); err != nil {
		return fmt.Errorf("send r to camp picker: %w", err)
	}
	if err := probe.waitFor("no-machines error", 12*time.Second, func(text string) bool {
		return strings.Contains(text, "no machines configured") && strings.Contains(text, "native-beginner")
	}); err != nil {
		return err
	}
	probe.record("no-machines error")
	probe.record("selection before g")

	if _, err := pty.Write([]byte("g")); err != nil {
		return fmt.Errorf("send g to camp picker: %w", err)
	}
	if err := waitForFile(pathOutput, 12*time.Second); err != nil {
		return fmt.Errorf("selected path was not persisted: %w", err)
	}
	result, err := windows.WaitForSingleObject(process, 12_000)
	if err != nil || result != windows.WAIT_OBJECT_0 {
		return fmt.Errorf("camp picker did not exit after g: wait=%d err=%v", result, err)
	}
	var exitCode uint32
	if err := windows.GetExitCodeProcess(process, &exitCode); err != nil || exitCode != 0 {
		return fmt.Errorf("camp picker exited with code %d: %v", exitCode, err)
	}
	finished = true
	if err := probe.drain(500 * time.Millisecond); err != nil {
		return err
	}
	probe.record("selection after g")

	selected, err := os.ReadFile(pathOutput)
	if err != nil {
		return fmt.Errorf("read selected path: %w", err)
	}
	if !sameWindowsPath(strings.TrimSpace(string(selected)), state.Camp) {
		return fmt.Errorf("selected path %q, expected beginner camp %q", selected, state.Camp)
	}
	readbackCtx, cancelReadback := context.WithTimeout(context.Background(), 12*time.Second)
	defer cancelReadback()
	cmd := exec.CommandContext(readbackCtx, campExe, "list", "--json")
	cmd.Dir = workRoot
	cmd.Env = os.Environ()
	readback, err := cmd.Output()
	if err != nil {
		return fmt.Errorf("fresh-process camp list --json: %w", err)
	}
	var entries []campEntry
	if err := json.Unmarshal(readback, &entries); err != nil {
		return fmt.Errorf("parse fresh-process camp list --json: %w", err)
	}
	if len(entries) != 1 || entries[0].Name != "native-beginner" ||
		!sameWindowsPath(entries[0].Path, state.Camp) {
		return fmt.Errorf("fresh-process camp list differs from selection: %+v", entries)
	}
	if !bytes.Contains(probe.raw.Bytes(), []byte("\x1b[")) {
		return errors.New("ConPTY capture contained no VT control sequences")
	}
	fmt.Printf("fresh-process camp list --json and selected path: %s\n", state.Camp)
	return nil
}

func (p *terminalProbe) readLoop() {
	defer close(p.chunks)
	buf := make([]byte, 32*1024)
	for {
		n, err := p.pty.Read(buf)
		if n > 0 {
			copyChunk := append([]byte(nil), buf[:n]...)
			p.chunks <- copyChunk
		}
		if err != nil {
			return
		}
	}
}

func (p *terminalProbe) consume(chunk []byte) error {
	if _, err := p.raw.Write(chunk); err != nil {
		return err
	}
	if err := p.screen.write(chunk); err != nil {
		return fmt.Errorf("render ConPTY VT stream: %w", err)
	}
	return nil
}

func (p *terminalProbe) waitFor(label string, timeout time.Duration, matches func(string) bool) error {
	deadline := time.NewTimer(timeout)
	defer deadline.Stop()
	for {
		if matches(p.screen.snapshot()) {
			return nil
		}
		select {
		case chunk, ok := <-p.chunks:
			if !ok {
				return fmt.Errorf("ConPTY output closed before %s appeared; screen:\n%s", label, p.screen.snapshot())
			}
			if err := p.consume(chunk); err != nil {
				return err
			}
		case <-deadline.C:
			return fmt.Errorf("timed out waiting for %s; screen:\n%s", label, p.screen.snapshot())
		}
	}
}

func (p *terminalProbe) drain(maxWait time.Duration) error {
	timer := time.NewTimer(maxWait)
	defer timer.Stop()
	for {
		select {
		case chunk, ok := <-p.chunks:
			if !ok {
				return nil
			}
			if err := p.consume(chunk); err != nil {
				return err
			}
		case <-timer.C:
			return nil
		}
	}
}

func (p *terminalProbe) record(event string) {
	f := frame{Event: event, Width: p.width, Height: p.height,
		VTBytes: p.raw.Len(), Screen: p.screen.snapshot()}
	p.frames = append(p.frames, f)
	fmt.Printf("--- %s (%dx%d, %d VT bytes) ---\n%s\n", f.Event, f.Width, f.Height, f.VTBytes, f.Screen)
}

func (p *terminalProbe) saveEvidence(workRoot string) error {
	if err := os.WriteFile(filepath.Join(workRoot, "terminal-capture.vt"), p.raw.Bytes(), 0o600); err != nil {
		return fmt.Errorf("save raw ConPTY VT capture: %w", err)
	}
	report, err := json.MarshalIndent(p.frames, "", "  ")
	if err != nil {
		return fmt.Errorf("encode rendered frames: %w", err)
	}
	if err := os.WriteFile(filepath.Join(workRoot, "terminal-frames.json"), report, 0o600); err != nil {
		return fmt.Errorf("save rendered frame report: %w", err)
	}
	return nil
}

func waitForFile(path string, timeout time.Duration) error {
	deadline := time.NewTimer(timeout)
	defer deadline.Stop()
	ticker := time.NewTicker(25 * time.Millisecond)
	defer ticker.Stop()
	for {
		if info, err := os.Stat(path); err == nil && info.Size() > 0 {
			return nil
		}
		select {
		case <-ticker.C:
		case <-deadline.C:
			return fmt.Errorf("timed out waiting for %s", path)
		}
	}
}

func sameWindowsPath(a, b string) bool {
	return strings.EqualFold(filepath.Clean(a), filepath.Clean(b))
}

var _ io.Reader = (*conpty.ConPty)(nil)
