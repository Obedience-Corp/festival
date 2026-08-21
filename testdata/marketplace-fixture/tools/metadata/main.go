// This is NOT the real marketplace verifier. It is a stand-in used only by
// scripts/test_marketplace_publish.sh so the fixture harness can drive both
// branches of publish_marketplace_entry.sh's pre-edit check deterministically,
// with no network and no real signing key. It does not check signatures or
// schema; it only reports the exit code the test asked for. The real
// verifier lives in Obedience-Corp/marketplace's own tools/metadata and is
// exercised in sequence 03, not here. A reader who mistakes this for the
// real verifier will draw the wrong conclusion from a green test.
package main

import (
	"fmt"
	"os"
	"strconv"
)

func main() {
	exit := 0
	if v := os.Getenv("FIXTURE_VERIFY_EXIT"); v != "" {
		parsed, err := strconv.Atoi(v)
		if err != nil {
			fmt.Fprintf(os.Stderr, "FIXTURE_VERIFY_EXIT must be an integer, got %q\n", v)
			os.Exit(2)
		}
		exit = parsed
	}
	if exit == 0 {
		fmt.Println("fixture verify: ok (FIXTURE_VERIFY_EXIT=0)")
	} else {
		fmt.Fprintln(os.Stderr, "fixture verify: broken (FIXTURE_VERIFY_EXIT set non-zero)")
	}
	os.Exit(exit)
}
