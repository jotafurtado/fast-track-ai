---
type: pointer
source: https://example.com/canonical-source
captured: YYYY-MM-DD
owner: maintainer
pin: immutable-version-commit-or-content-id
sha256: 64-lowercase-hex-digest-of-observed-source-payload
content_license: unknown
---

# Ref: slug

## Capture notes
State how the source payload was obtained and hashed. Record partial retrieval explicitly.

## Locator
Canonical source locator. Do not copy protected content into this file.

## Contract

- Maximum file size: 500 KB.
- Required for both types: `type`, `captured`, `owner`, `sha256`, and `content_license`.
- `content_license` is the source-content license, or `unknown` when no explicit license is available.
- `inline`: omit `source`, `pin`, and `retrieved_at`. Store the exact redistributable source after `## Source content`. Normalize it to UTF-8 with LF line endings and exactly one terminal LF. `sha256` covers only those normalized source bytes, not frontmatter, headings, or capture notes.
- `pointer`: require canonical `source`. Use `pin` when the upstream exposes an immutable version, release, commit, or content identifier. Otherwise replace `pin` with `retrieved_at: YYYY-MM-DDTHH:MM:SSZ`. `sha256` covers the source payload actually observed at capture time, never the URL, path, locator text, or this Markdown file.
- Before creating a ref, compare the candidate content hash with existing refs. Reuse an existing matching ref and slug instead of creating a duplicate.
- Source representation and identity fields are immutable. Changed source bytes require a new ref. Schema-only metadata may be enriched without changing source identity or hash.
- If the source cannot be retrieved or supplied after one direct request, create no ref and no synthetic hash. Record the missing basis in the consuming intent as an open question or explicit assumption.

## Source content

Inline refs replace this paragraph with the exact normalized source text. Pointer refs omit this section.
