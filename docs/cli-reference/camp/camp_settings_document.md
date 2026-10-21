---
title: "camp settings document"
linkTitle: "camp settings document"
description: "Read and edit camp documents"
---

## camp settings document

Read and edit camp documents

### Synopsis

Read, validate, and edit documents under the selected camp's .campaign directory.

Paths are relative to .campaign. Known catalog IDs are accepted wherever a path is.
Reads and validation do not create or rewrite files. Mutations require
--expected-revision and return the persisted snapshot.

### Options

```
  -h, --help   help for document
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp settings](../camp_settings/)	 - Manage camp configuration
* [camp settings document action](../camp_settings_document_action/)	 - Run an owner action on a camp document
* [camp settings document create](../camp_settings_document_create/)	 - Create a camp document from stdin
* [camp settings document delete](../camp_settings_document_delete/)	 - Delete a camp document
* [camp settings document get](../camp_settings_document_get/)	 - Print one camp document
* [camp settings document patch](../camp_settings_document_patch/)	 - Patch a camp document from stdin
* [camp settings document rename](../camp_settings_document_rename/)	 - Rename a camp document
* [camp settings document set](../camp_settings_document_set/)	 - Replace a camp document from stdin
* [camp settings document validate](../camp_settings_document_validate/)	 - Validate camp document source from stdin
