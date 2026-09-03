# AGENTS.md — Workspace instructions for AI coding agents

Purpose
- Quickly orient an AI coding agent to build, test, and modify this Flutter/Dart project.
- Keep minimal, link-heavy guidance so agents can discover details in-source.

Quickstart (commands an agent may run)
- Install dependencies: `flutter pub get` — see [pubspec.yaml](pubspec.yaml).
- Regenerate codegen (DI, serializers): `dart run build_runner build` — see [lib/injection.dart](lib/injection.dart).
- Run unit tests: `flutter test` — see [test/](test/).
- Run app (desktop): `flutter run -d linux|windows|macos` — entry point [lib/main.dart](lib/main.dart).
- Build release artifacts: `flutter build linux`, `flutter build windows`, `flutter build macos` — packaging helpers in [packaging/](packaging/).

Project layout highlights (links)
- Entrypoint: [lib/main.dart](lib/main.dart)
- UI widgets: [lib/widgets/](lib/widgets/)
- State (Redux): [lib/store/store.dart](lib/store/store.dart) and [lib/store/app_state.dart](lib/store/app_state.dart)
- Dependency Injection: [lib/injection.dart](lib/injection.dart) (generated file: [lib/injection.config.dart](lib/injection.config.dart))
- Domain/usecases: [lib/domain/](lib/domain/) and [lib/usecases/](lib/usecases/)
- Native build scripts: [linux/CMakeLists.txt](linux/CMakeLists.txt), [macos/Podfile](macos/Podfile), [windows/CMakeLists.txt](windows/CMakeLists.txt)

Conventions agents should follow
- Do not edit generated files (e.g., [lib/injection.config.dart](lib/injection.config.dart)); run `dart run build_runner build` to update them.
- Follow existing naming: snake_case filenames and `*.widget.dart` for widgets.
- Use existing state management patterns (Redux): add actions/reducers/middleware in `lib/store/`.
- When proposing changes, run unit tests (`flutter test`) and regenerate codegen as needed.

Agent best practices
- Prefer linking into source files rather than duplicating docs; include short actionable steps only.
- Run `flutter analyze` and `flutter test` before opening PRs.
- When changing DI, ensure `dart run build_runner build` is run and tests pass.
