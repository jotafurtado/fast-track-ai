# Quickstart: Skill Standards Compliance

Validates the migration end to end on scratch repos. Never run against a live target.

## Prerequisites

Bash, `grep`, `sed`, `awk`. Empty scratch dir, e.g. `/tmp/skill-std-test`.

## 1. Audit passes

```bash
# every checklist item has an evidence quote for all 6 skills
grep -c "evidence" specs/001-skill-standards/audit.md  # expect >= items × skills
```

Expected: audit file exists, no item without a quote.

## 2. Per-skill layout resolves after install

```bash
./install.sh --agents-dir /tmp/skill-std-test/skills --claude-dir /tmp/skill-std-test/claude
test -f /tmp/skill-std-test/skills/dot-ai-plan/scripts/sdd-gate.sh
test ! -e /tmp/skill-std-test/skills/shared
```

Expected: owner copies present, no `shared` link.

## 3. Flow still green

```bash
SK=/tmp/skill-std-test/skills/dot-ai-init
$SK/scripts/dot-ai-init.sh /tmp/skill-std-test/target
```

Expected: `dot-ai ready`, tree created, no `scripts/` or `templates/` inside target. Then index passes and gate FAILs on open tasks, PASSes when checked, per `contracts/skill-package.md` path rules.
