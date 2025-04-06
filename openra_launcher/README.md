# openra_launcher

A desktop application for launching OpenRA mods.

## Getting Started

Install the Flutter SDK. Then run flutter commands in this directory:

```sh
# Install dependencies
flutter pub get

# Generate code
flutter pub run build_runner build

# Run the app directly
flutter run
```

To produce build artifacts:
```sh
# Produce Linux build artifacts
flutter build linux

# Produce Windows build artifacts
flutter build windows

# Produce MacOS build artifacts
flutter build macos
```

To run tests:
```sh
flutter test
```

## Packaging

On Linux the app is packaged as an AppImage. Use the provided scripts to achieve that.

On Windows the app is manually packaged as a portable executable in a zip archive.

On MacOS the app is manually packaged as an app archive.
