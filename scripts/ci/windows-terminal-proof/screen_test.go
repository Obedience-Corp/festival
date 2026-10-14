package main

import (
	"strings"
	"testing"
)

func TestTerminalScreenAppliesRepaintAndResize(t *testing.T) {
	s := newTerminalScreen(40, 12)
	if err := s.write([]byte("\x1b[?1049h\x1b[HOld text\r\n")); err != nil {
		t.Fatal(err)
	}
	if !strings.Contains(s.snapshot(), "Old text") {
		t.Fatalf("alternate-screen first paint absent: %q", s.snapshot())
	}
	if err := s.write([]byte("\x1b[H\x1b[2JCamps\r\nnative-beginner")); err != nil {
		t.Fatal(err)
	}
	frame := s.snapshot()
	if strings.Contains(frame, "Old text") || !strings.Contains(frame, "Camps") || !strings.Contains(frame, "native-beginner") {
		t.Fatalf("cursor/clear repaint rendered incorrectly: %q", frame)
	}
	s.resize(24, 8)
	if s.emu.Width() != 24 || s.emu.Height() != 8 {
		t.Fatalf("resize did not reach VT emulator: %dx%d", s.emu.Width(), s.emu.Height())
	}
}
