# Project Summary
Oil Price Tracker - Web Scraper & Firebase Integration

Architecture:
Modular Python Scripts (Scraper -> Data Processor -> Firebase Connector)

Primary language:
Python 3.x

Target:
Windows Task Scheduler / Cloud Cron Job

# Workflow
## Success Flow
```
Planning
↓
Plan Review
↓
Implementation (Python Coding)
↓
Developer Validation (Local Execution / Unit Test)
↓
Verification (Test API & Firebase Output)
↓
Release (Deploy to Scheduler)
```

## Fail Flow
```
Verification FAIL
↓
Failure Classification
↓
Requirement -> Planning
Planning -> Planning
Implementation -> Debug
Environment (e.g. Network, Firebase Config) -> Infrastructure
Unknown -> Investigation
↓
Debug / Re-Implementation
↓
Developer Validation
↓
Verification
```

## Issue Management
Rules:
- `requirement_gap` (Missing field reqs) -> `Planning`
- `implementation_regression` (Scraper fails to parse) -> `Debug`
- `verification_failure` (Data format incorrect) -> `Debug`
- `environment` (Missing `.env` or Firebase key) -> `Infrastructure`

---

# Task Lifecycle & State Management
For every new feature, bug fix, or major phase, manage state using a Task Folder.

## 1. Planning Phase
Create these files at `docs/tasks/{task_name}-{MMDD}/`:
- `{MMDD}-requirement.md`
- `{MMDD}-plan.md`
- `state.md`

`state.md` must be initialized as:
```markdown
- phase: planning
- status: plan_ready
- next_action: plan_review
```

## 2. Implementation Phase
When developing, read `plan.md` and `state.md`.
Update `state.md` when done:
```markdown
- phase: implementation
- status: implementation_complete
- implementation_status: completed
- next_action: verification
```

## 3. Verification Phase
Create file: `docs/tasks/{task_name}-{MMDD}/{MMDD}-verification.md`

If PASS:
```markdown
- phase: verification
- status: verification_passed
- next_action: release
```

If FAIL:
```markdown
- phase: verification
- status: verification_failed
- verification_result: fail
- category: implementation
- failed_acceptance_criteria: DOM element missing
- next_action: debug
```

---

# Role Routing (Required Reading)
Before executing a phase, read the corresponding rules:
- Planning -> `ai/planning-rules.md`
- Developer -> `ai/developer-rules.md`
- Verifier -> `ai/verification-rules.md`

# Global Rules for AI Agents:
- **No hardcoded secrets:** Never hardcode Firebase credentials.
- **Do not overwrite production data blind:** During testing, write to a "test" node in Firebase.
- **Do not modify requirements without user approval.**
- **Do not skip tests.**
