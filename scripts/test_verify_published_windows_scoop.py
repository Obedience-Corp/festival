"""In-memory fixtures for the stable release's published Scoop gate."""

import copy
import hashlib
import io
import unittest
import zipfile

from verify_published_windows_scoop import verify


TAG = "v1.2.3"
NAME = "festival-1.2.3-windows-x86_64.zip"
URL = f"https://github.com/Obedience-Corp/festival/releases/download/{TAG}/{NAME}"


def fixture(members=None):
    if members is None:
        members = {"camp.exe": b"MZcamp", "fest.exe": b"MZfest",
                   "festival.exe": b"MZfestival"}
    stream = io.BytesIO()
    with zipfile.ZipFile(stream, "w") as bundle:
        for name, body in members.items():
            bundle.writestr(name, body)
    archive = stream.getvalue()
    digest = hashlib.sha256(archive).hexdigest()
    manifest = {
        "version": "1.2.3",
        "architecture": {"64bit": {
            "url": URL,
            "hash": digest,
            "bin": ["camp.exe", "fest.exe", "festival.exe"],
        }},
    }
    return archive, f"{digest}  {NAME}\n", manifest


class PublishedScoopVerificationTest(unittest.TestCase):
    def test_matching_published_assets_and_bucket(self):
        archive, checksums, manifest = fixture()
        report = verify(TAG, NAME, archive, checksums, manifest)
        self.assertIn("verified published v1.2.3", report)

    def test_rejects_stale_bucket_after_partial_publish(self):
        archive, checksums, manifest = fixture()
        stale = copy.deepcopy(manifest)
        stale["version"] = "1.2.2"
        with self.assertRaisesRegex(ValueError, "bucket version"):
            verify(TAG, NAME, archive, checksums, stale)

    def test_rejects_wrong_release_url_or_hash(self):
        archive, checksums, manifest = fixture()
        for field, value, diagnostic in (
            ("url", URL.replace(TAG, "v1.2.2"), "bucket URL"),
            ("hash", "0" * 64, "bucket hash"),
        ):
            with self.subTest(field=field):
                changed = copy.deepcopy(manifest)
                changed["architecture"]["64bit"][field] = value
                with self.assertRaisesRegex(ValueError, diagnostic):
                    verify(TAG, NAME, archive, checksums, changed)

    def test_rejects_wrong_commands_or_architecture(self):
        archive, checksums, manifest = fixture()
        missing_command = copy.deepcopy(manifest)
        missing_command["architecture"]["64bit"]["bin"] = ["camp.exe", "fest.exe"]
        with self.assertRaisesRegex(ValueError, "three Scoop commands|expose"):
            verify(TAG, NAME, archive, checksums, missing_command)
        extra_arch = copy.deepcopy(manifest)
        extra_arch["architecture"]["32bit"] = {}
        with self.assertRaisesRegex(ValueError, "only Windows x64"):
            verify(TAG, NAME, archive, checksums, extra_arch)

    def test_rejects_missing_or_mismatched_published_asset(self):
        archive, checksums, manifest = fixture()
        for name, data, digest_file, diagnostic in (
            ("wrong-name.zip", archive, checksums, "published Windows asset"),
            (NAME, archive + b"changed", checksums, "bucket hash"),
            (NAME, archive, "0" * 64 + f"  {NAME}\n", "published checksums"),
            (NAME, archive, checksums + checksums, "published checksums"),
        ):
            with self.subTest(diagnostic=diagnostic, name=name):
                with self.assertRaisesRegex(ValueError, diagnostic):
                    verify(TAG, name, data, digest_file, manifest)

    def test_rejects_incomplete_or_non_windows_zip(self):
        for members, diagnostic in (
            ({"camp.exe": b"MZcamp", "fest.exe": b"MZfest"}, "missing a suite executable"),
            ({"camp.exe": b"MZcamp", "fest.exe": b"MZfest",
              "festival.exe": b"not a Windows binary"}, "not a Windows executable"),
            ({"camp.exe": b"MZcamp", "fest.exe": b"MZfest",
              "festival.exe": b"MZfestival", "../escape.txt": b"unsafe"}, "unsafe path"),
        ):
            with self.subTest(diagnostic=diagnostic):
                archive, checksums, manifest = fixture(members)
                with self.assertRaisesRegex(ValueError, diagnostic):
                    verify(TAG, NAME, archive, checksums, manifest)

    def test_rejects_prerelease_tag(self):
        archive, checksums, manifest = fixture()
        with self.assertRaisesRegex(ValueError, "stable release tag"):
            verify("v1.2.3-rc.1", NAME, archive, checksums, manifest)


if __name__ == "__main__":
    unittest.main()
