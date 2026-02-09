---
name: maestro
description: "Create Maestro UI test flows for user stories and features"
user_invocable: true
---

# Maestro UI Testing Skill

Create Maestro test flows for user stories and features.

## Steps

1. **Identify the test scope**:
   - Single story → create `{test_dir}/S{XX}-{feature}.yaml`
   - Reusable flow (login, navigation) → create `{test_dir}/flows/{name}.yaml`
   - Full feature suite → create multiple flows + index file

2. **Determine the app ID**:
   - Check your project's app config for the bundle identifier
   - Default: `{your.app.bundleIdentifier}`

3. **Write the flow using Maestro YAML syntax**:

   ```yaml
   appId: {your.app.bundleIdentifier}
   ---
   # Test: {Story title or feature description}

   - launchApp
   - assertVisible: "Expected screen element"
   - tapOn: "Button text"
   - inputText: "test input"
   - assertVisible: "Success message"
   ```

4. **Use appropriate selectors** (in order of preference):
   - `text: "Visible text"` — most readable, use for static content
   - `id: "accessibility_id"` — use for dynamic content or icons
   - `point: 50%, 50%` — last resort for complex layouts

5. **Include standard test patterns**:
   - Happy path (main user flow)
   - Error states (invalid input, network errors)
   - Edge cases (empty states, long text)

## Maestro Command Reference

| Command | Syntax | Use Case |
|---------|--------|----------|
| `launchApp` | `- launchApp` | Start the app |
| `tapOn` | `- tapOn: "Text"` | Tap button/element |
| `inputText` | `- inputText: "value"` | Type in focused field |
| `assertVisible` | `- assertVisible: "Text"` | Verify element exists |
| `assertNotVisible` | `- assertNotVisible: "Text"` | Verify element hidden |
| `scroll` | `- scroll` | Scroll down |
| `swipe` | `- swipe: {direction: "LEFT"}` | Swipe gesture |
| `back` | `- back` | Android back button |
| `hideKeyboard` | `- hideKeyboard` | Dismiss keyboard |
| `takeScreenshot` | `- takeScreenshot: "name"` | Capture screen |
| `runFlow` | `- runFlow: "flows/login.yaml"` | Reuse another flow |
| `waitForAnimationToEnd` | `- waitForAnimationToEnd` | Wait for animations |

## Selector Options

```yaml
# By text (preferred)
- tapOn: "Submit"

# By accessibility ID
- tapOn:
    id: "submit_button"

# By text with index (when multiple matches)
- tapOn:
    text: "Item"
    index: 0

# By position relative to other elements
- tapOn:
    below: "Header"
    text: "Button"

# By screen coordinates (last resort)
- tapOn:
    point: 50%, 90%
```

## Usage

```
/maestro S42              # Create test flow for story S42
/maestro login            # Create reusable login flow
/maestro "onboarding"     # Create test for onboarding feature
```

## Output

- Flow file created in the project's test directory
- Includes assertions for acceptance criteria
- Ready to run with `maestro test {path-to-flow}.yaml`

## Running Tests

After creating flows, run them:

```bash
# Single flow
maestro test {test_dir}/S42-feature.yaml

# All flows
maestro test {test_dir}/

# With screenshots on failure
maestro test --debug-output ./screenshots {test_dir}/S42-feature.yaml
```

## Best Practices

1. **One flow per user journey** — not one flow per screen
2. **Use text selectors** — they read like user instructions
3. **Add waits after navigation** — `waitForAnimationToEnd` or explicit delays
4. **Reuse login flows** — `runFlow: "flows/login.yaml"`
5. **Test error states** — not just happy paths
6. **Keep flows short** — 10-20 steps max, split if longer
