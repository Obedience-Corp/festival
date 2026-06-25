import json, sys, datetime

index_path, pkg_id, channel = sys.argv[1], sys.argv[2], sys.argv[3]

with open(index_path) as fh:
    index = json.load(fh)

index.setdefault("source", "official-obey")
packages = index.setdefault("packages", [])

changed = False
entry = next((p for p in packages if p.get("id") == pkg_id), None)
if entry is None:
    entry = {"id": pkg_id, "channels": []}
    packages.append(entry)
    changed = True

channels = entry.setdefault("channels", [])
if channel not in channels:
    channels.append(channel)
    channels.sort()
    changed = True

if not changed:
    sys.exit(0)

index["updatedAt"] = datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")

with open(index_path, "w") as fh:
    json.dump(index, fh, indent=2)
    fh.write("\n")
