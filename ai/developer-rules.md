# Developer Rules

## 1. Input Requirements
Before writing any code, the Developer MUST read:
- `plan.md`
- `state.md`
Ensure that the task has been reviewed and approved by the user.

## 2. Iterative Execution (Small Steps)
Implement the code step-by-step according to `plan.md`. Run local tests after each major function is written to ensure accuracy.

## 3. Security
Never hardcode sensitive information (e.g., Firebase Service Account Keys, API keys). Always use `.env` files and guide the user on how to set them up securely.

## 4. State Management
Upon completion and passing local developer validation, update `state.md` to reflect the progress:
```markdown
- phase: implementation
- status: implementation_complete
- implementation_status: completed
- next_action: verification
```
