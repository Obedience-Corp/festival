package main

import vt "github.com/charmbracelet/x/vt"

// terminalScreen consumes the original VT byte stream, including cursor moves,
// clears, and alternate-screen switches. Assertions use its rendered cells.
type terminalScreen struct {
	emu *vt.Emulator
}

func newTerminalScreen(width, height int) *terminalScreen {
	return &terminalScreen{emu: vt.NewEmulator(width, height)}
}

func (s *terminalScreen) write(data []byte) error {
	_, err := s.emu.Write(data)
	return err
}

func (s *terminalScreen) resize(width, height int) {
	s.emu.Resize(width, height)
}

func (s *terminalScreen) snapshot() string {
	return s.emu.String()
}
