---
type: pointer
source: https://example.com/source
captured: YYYY-MM-DD
owner: maintainer
pin: commit-or-version
sha256: replace-with-hex-digest-of-the-pinned-source
---

# Ref: slug

`type` is `inline` or `pointer`. Max 500 KB. `sha256` is required.

- **inline**: put the full durable text in the body. `source` and `pin` are optional.
- **pointer**: body is a short locator. `source`, `pin`, and `sha256` (of the pinned content) are required.

`refs/` is immutable. Source changed, new file.
