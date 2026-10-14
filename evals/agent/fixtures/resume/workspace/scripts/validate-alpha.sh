#!/bin/sh
# Resume fixture: records every invocation so the eval can prove that the
# checked task's Validate was not rerun.
: >.eval-validate-alpha-ran
printf '%s\n' 'FTAI_VALIDATION_EXECUTED:resume:alpha'
test "$(cat alpha.txt)" = alpha
