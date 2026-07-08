# BUILD.md

This repository is a Flutter desktop application. Use this guide for local builds, code generation, tests, and native packaging.

## Prerequisites

- Flutter SDK installed and on `PATH`

## Setup

```sh
flutter pub get
```

## Code generation

This project uses dependency injection codegen.

```sh
dart run build_runner build
```

## Run locally

```sh
flutter run
```

## Build artifacts

```sh
flutter build linux
flutter build windows
flutter build macos
```

## Tests

```sh
flutter test
```

## Packaging notes

### Linux

The app is packaged as an AppImage using helper scripts in `packaging/`.

### macOS

The macOS build is created with Flutter and native macOS bundle tooling.
A working Xcode installation and CocoaPods are required.

### Windows

Windows packaging is built with Flutter and the Windows native build scripts in `windows/`.
A supported Visual Studio installation is required.

## Recommended workflow

1. `flutter pub get`
2. `dart run build_runner build`
3. `flutter test`
4. `flutter run` or `flutter build <platform>`

## Links

- [lib/main.dart](lib/main.dart)
- [lib/injection.dart](lib/injection.dart)
- [linux/CMakeLists.txt](linux/CMakeLists.txt)
- [macos/Podfile](macos/Podfile)
- [windows/CMakeLists.txt](windows/CMakeLists.txt)
- [packaging/package-linux.sh](packaging/package-linux.sh)
- [packaging/AppImageBuilder.yml](packaging/AppImageBuilder.yml)
