#!/bin/sh
# Deterministic failure fixture: the greeting registry is never reachable, so
# this Validate command always exits 1 regardless of greeting.txt.
echo "check-greeting: greeting registry unreachable" >&2
exit 1
