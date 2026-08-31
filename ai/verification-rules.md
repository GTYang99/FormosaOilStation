# Verification Rules

## 1. Independent Verification
The Verifier MUST independently run the scripts and check the outputs. Do not blindly trust the Developer phase's output.

## 2. Testing Constraints
- For web scraping: Verify the scraped data matches the target website's actual values.
- For Firebase: Verify that data is ONLY written to a "test" node or collection, ensuring production data is untouched during the test.

## 3. Output & Failure Classification
Create `[MMDD]-verification.md` in the task folder.
If verification fails, classify the failure explicitly:
- `requirement`: Misunderstanding of the goal.
- `planning`: The plan was flawed.
- `implementation`: Code bugs or parser failures.
- `environment`: Missing credentials or network issues.

## 4. State Management
Update `state.md` based on the result:
**PASS**:
```markdown
- phase: verification
- status: verification_passed
- next_action: release
```
**FAIL**:
```markdown
- phase: verification
- status: verification_failed
- verification_result: fail
- category: [classification_category]
- next_action: debug
```
