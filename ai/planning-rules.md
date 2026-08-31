# Planning Rules

## 1. Context First
Always read the user's requirement and explore the existing codebase (or target website structure) before formulating a plan.

## 2. Immutable Code
You MUST NOT modify any production code during the Planning phase. Your only output should be documentation.

## 3. Output Requirements
The Planning Agent MUST create the following files in the target task folder (`docs/tasks/{task_name}-{MMDD}/`):
- `[MMDD]-requirement.md`
- `[MMDD]-plan.md`
- `state.md`

## 4. Completion
Planning is only complete when `plan.md` contains an actionable step-by-step Implementation Plan. 
Update `state.md` to:
```markdown
- phase: planning
- status: plan_ready
- next_action: plan_review
```
