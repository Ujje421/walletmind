# Rules & Coding Standards

This document defines the strict engineering guidelines the AI (and all human engineers) must follow when building WalletMind.

## 1. General Rules
- **No Placeholders**: Never write `// TODO: Implement later` unless explicitly requested. Implement fully functional code.
- **Fail Fast**: If requirements are unclear, do not guess. Surface the ambiguity.
- **Performance First**: The app must run at 60/120 FPS. Do not block the main thread.
- **DRY (Don't Repeat Yourself)**: Extract reusable widgets, functions, and styles.

## 2. Coding Standards
- **Language**: Dart 3.x (Frontend), Python 3.11+ (Backend).
- **Immutability**: Use `final` and `const` everywhere possible in Dart. Use `freezed` for immutable models.
- **Null Safety**: Strict null safety required. Never use the `!` operator (bang operator) to force unwrap unless absolutely proven safe (and even then, prefer `if (value != null)`).

## 3. Naming Conventions
- **Files**: `snake_case.dart`
- **Classes/Types**: `PascalCase`
- **Variables/Methods**: `camelCase`
- **Constants**: `SCREAMING_SNAKE_CASE` or `lowerCamelCase` (Dart standard prefers lowerCamelCase, but strictly adhere to local lint rules).
- **Private fields**: Must start with an underscore `_`.

## 4. Architecture Rules
- Strictly adhere to Feature-First Clean Architecture.
- **UI cannot talk to the Database**: UI -> Provider/Notifier -> Repository -> Database.
- Never mix business logic into UI widgets.

## 5. Folder Rules
- Feature folders must contain `presentation`, `domain`, and `data` layers.
- Shared resources go into `core/`. Do not cross-import between features (e.g., `features/chat` should not import directly from `features/dashboard`). If they share data, promote it to `core/` or use dependency injection to interface it.

## 6. Dependency Rules
- Minimize external dependencies. Every new package is a liability.
- Before adding a package, ensure it is actively maintained and supports the latest Dart/Flutter versions.

## 7. Error Handling Rules
- Never use generic `catch (e)`. Catch specific exceptions.
- Use a `Failure` class (via functional programming constructs like `fpdart` or just sealed classes) to return errors to the UI layer instead of throwing exceptions.
- Why: Exceptions break control flow and are hard to track. Returning `Result<T, Failure>` makes error handling explicit.

## 8. Logging Rules
- Never use `print()`. Use the `logger` package.
- `logger.d()` for debug, `logger.e()` for errors with stack traces.
- Exclude sensitive financial data from logs entirely.

## 9. Testing Rules
- Every business logic class (UseCases, Parsers) must have 100% unit test coverage.
- Repositories should be tested with mock data sources.
- Golden tests for complex UI components.

## 10. Security Rules
- No API keys in source code. Use `.env`.
- Database encryption must be enabled for production builds.

## 11. Accessibility Rules
- Use `Semantics` widget for non-standard custom UI elements.
- Text must scale gracefully. Do not hardcode heights that clip text when a user increases system font size.

## 12. Animation Rules
- Use `flutter_animate` for micro-interactions to keep code clean.
- Keep animations snappy (< 300ms). Do not make the user wait for an animation to finish before they can interact.

## 13. State Management Rules (Riverpod)
- Use `AsyncNotifierProvider` for async data.
- Avoid global mutable state.
- Keep providers scoped locally where possible.

## 14. Best Practices for AI Integrations
- Handle latency gracefully. Provide optimistic UI updates or skeleton loaders while AI parses text.
- Fallback gracefully: If AI fails, the user must still be able to input data manually without being blocked.

## 15. Forbidden Practices
- NEVER use global variables.
- NEVER block the UI thread with heavy computations (use `Isolate.run`).
- NEVER leave `print` statements in production code.
- NEVER embed credentials.

## 16. Approved Libraries (Flutter)
- `flutter_riverpod` (State)
- `isar` (Local Database)
- `freezed` & `json_serializable` (Models)
- `speech_to_text` (Voice)
- `fl_chart` (Charts)
- `flutter_animate` (Animations)
- `dio` (Networking)

## 17. PR & Code Review Checklist
- [ ] `flutter analyze` passes with 0 issues.
- [ ] Logic tested and passes.
- [ ] State handled for Loading, Error, and Success states.
- [ ] No hardcoded colors or text styles (use Theme).
