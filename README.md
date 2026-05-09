## Features

- Convert between binary, decimal, octal, and hexadecimal.
- Swap input and output bases with one tap.
- Supports negative numbers and very large integer values with Dart `BigInt`.
- Shows helpful validation messages when an input does not match the selected base.
- Includes widget tests for the default output state and invalid binary input handling.

## Project Structure

```text
lib/
  main.dart
  models/
    number_base.dart
  screens/
    converter_screen.dart
  widgets/
    converter_widgets.dart
```

## Requirements

- Flutter SDK
- Dart SDK, included with Flutter
- iOS Simulator, Android Emulator, or a connected device

## Run the App

```sh
flutter pub get
flutter run
```

## Verify the Project

```sh
flutter analyze
flutter test
```

## Supported Bases

| Base | Radix | Example |
| --- | ---: | --- |
| Binary | 2 | `101101` |
| Decimal | 10 | `45` |
| Octal | 8 | `55` |
| Hexadecimal | 16 | `2D` |
