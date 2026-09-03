#!/bin/bash

# Set the working dir to the location of this script using bash parameter expansion
cd "${0%/*}" || exit 1

set -e

# Extract the build name and number from pubspec.yaml
file=$(cat ./../pubspec.yaml)

BUILD_NAME=$(echo $file | sed -nre 's/^[^0-9]*(([0-9]+\.)*[0-9]+).*/\1/p')
BUILD_NUMBER=$(git rev-list HEAD --count)

echo "Building version ${BUILD_NAME}+${BUILD_NUMBER}"

export BUILD_NAME="$BUILD_NAME"
export BUILD_NUMBER="$BUILD_NUMBER"

# Build app
flutter pub run build_runner build
flutter build linux

# Package AppImage
appimage-builder --recipe AppImageBuilder.yml --skip-tests

echo "Successfuly built and packaged version ${BUILD_NAME}+${BUILD_NUMBER}"
