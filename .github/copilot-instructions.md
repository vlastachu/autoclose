# Copilot Instructions for AutoClose Monorepo

Write in project only on english. Write less stupid comments. Only docs and unobvious moments (this is not programming tutorial). Если я пишу на русском то можешь отвечать на русском но веди проект и документацию только на английском!

## Overview
This monorepo contains the AutoClose family of Dart/Flutter packages for automatic resource management (e.g., closing/disposal of streams, subscriptions, timers, etc.). The core idea is to reduce boilerplate and prevent resource leaks by providing mixins, utilities, and lints that automate or enforce correct resource cleanup.

## Major Components
- **`lib/`**: Core resource management logic (see `autoclose.dart`, `autoclosable/`, `closer/`, `single_autoclosable/`, `subautoclosable/`).
- **`packages/`**: Platform- and framework-specific integrations:
  - `autoclose_bloc`: Bloc integration (see `AutoCloseBloc` mixin)
  - `autoclose_flutter`: Flutter integration (see `AutoCloseFlutter` mixin)
  - `autoclose_dio`: (WIP) Dio integration
  - `autoclose_lint`: Custom lints for enforcing resource management patterns
- **`assets/`**: Diagrams and GIFs for documentation
- **`test/`**: Unit and integration tests for core and submodules

## Key Patterns & Conventions
- **Mixin-based resource management**: Classes (e.g., Blocs, Widgets) use mixins like `AutoCloseBloc` or `AutoCloseFlutter` to automatically track and close resources via `.closeWith(this)`.
- **Lints for enforcement**: The `autoclose_lint` package provides custom lints (via `custom_lint`) to detect missing resource cleanup and suggest fixes.
- **Minimal manual cleanup**: Avoid explicit `dispose`/`close` methods where possible; prefer mixin-driven automation.
- **Ignore exceptions**: Use `// ignore:` comments for rare cases where resource lifetime intentionally diverges from the owning class.

## Developer Workflows
- **Build**: Standard Dart/Flutter build commands (`dart build`, `flutter build`, etc.)
- **Test**: Run all tests with `dart test` or `flutter test` in the root or relevant package directory.
- **Lint**: Enable lints by adding `custom_lint` and `autoclose_lint` to `dev_dependencies` and configuring `analysis_options.yaml`:
  ```yaml
  analyzer:
    plugins:
      - custom_lint
  ```
- **IDE Integration**: Use VS Code (`Cmd+.`) or IntelliJ (`Alt+Enter`) to auto-apply lint fixes (e.g., add mixins, insert `closeWith`).

## External Dependencies
- [custom_lint](https://pub.dev/packages/custom_lint) for custom linting
- [flutter_bloc](https://pub.dev/packages/flutter_bloc) for Bloc integration
- [dio](https://pub.dev/packages/dio) for HTTP client integration (WIP)

## Examples
- See `README.md` in each package for usage examples and integration details.
- Core usage: Add the relevant mixin to your class and use `.closeWith(this)` on resources.

## Project Structure Rationale
- Monorepo for shared code, consistent patterns, and cross-package testing
- Each integration (Flutter, Bloc, Dio, Lint) is a separate package for modularity

---
For more, see the main [`README.md`](../README.md) and package-level READMEs.
