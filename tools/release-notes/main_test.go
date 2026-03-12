package main

import "testing"

func TestIsReleaseMissing(t *testing.T) {
	tests := []struct {
		name string
		err  string
		want bool
	}{
		{name: "release not found", err: "gh release view: release not found", want: true},
		{name: "http 404", err: "gh release view: HTTP 404: Not Found", want: true},
		{name: "could not find release", err: "Could not find release for tag", want: true},
		{name: "other gh failure", err: "gh release view: authentication failed", want: false},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := isReleaseMissing(fakeError(tt.err))
			if got != tt.want {
				t.Fatalf("isReleaseMissing(%q) = %v, want %v", tt.err, got, tt.want)
			}
		})
	}
}

type fakeError string

func (e fakeError) Error() string { return string(e) }
