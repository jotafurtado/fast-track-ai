# Design

## Context

See `proposal.md` (Why) and `specs/implement-workflow/spec.md`. Implement step 4 says "Launch groups in dependency order" and step 5 says to set the checkbox "before starting the next dependent group". In the recorded run the agent read these as ordering of checkbox writes, not as a ban on edits: it created both groups' files, then ran both Validates.

## Goals / Non-Goals

**Goals:**
- Make the ban on touching a dependent group's Files before its prerequisites pass explicit in the skill text.
- Cover the rule with a deterministic text assertion and with the real `failed-validation` scenario.

**Non-Goals:**
- Changing the gate, the tasks template, or the agent-eval runner.
- Making the gate detect early-created dependent files; it cannot see edit history.

## Decisions

### Textual rule in the skill, no new mechanism
The fix is one normative sentence in the group-handling step, naming a checkable condition and prohibition: do not create, edit, or delete a dependent task's Files, including to collect evidence. The evidence clause targets the observed reasoning ("create both files ... to capture evidence").

Alternative considered: a script that blocks edits. Rejected because the method does not control the harness's edit tools.

### Non-blocking behavioral acceptance
Acceptance is `failed-validation` reporting `pass`. Model output varies, so an `inconclusive` run is repeated and a `fail` reopens the wording. Results go to the "Recorded Agent Run" table in `evals/evals.md`; the deterministic suite stays Kiro-free.

## Risks / Trade-offs

- [The model still violates the rule despite the text] → Record the `fail` with diagnostics and strengthen the wording, for example by moving the rule next to the Validate step.
- [One passing run does not prove the behavior holds] → Require at least two passing runs and record the run count.
