![Dart](https://github.com/DmitryVoronko/images_keys/workflows/Dart/badge.svg)

A simple and easy command-line generation tool generating image assets keys for Dart and Flutter projects. 
Inspired by [easy_localization:generate](https://github.com/aissat/easy_localization#-code-generation).

# Motivation

In Flutter you need use asset path string directly:

```dart
Image.asset('assets/images/image.png')
```

You trust the human factor to validate the path correctness to the asset. It is not safe.
If you get wrong you know it later in runtime only.

The safe way to pass it to generation tool:

```dart
Image.asset(ImagesKeys.image_png)
```

# Installation

Add to your pubspec.yaml:

```yaml
dependencies:
  images_keys: <last_version>
```

# Usage

You can simply get information about command line arguments. 
Open terminal in your project path and run command:

```cli
pub run images_keys:images_keys -h
```

for flutter:

```cli
flutter pub run images_keys:images_keys -h
```

### Command line arguments

| Arguments | Short |  Default | Description |
| ------ | ------ |  ------ | ------ |
| --help | -h |  | Help info |
| --source-dir | -S | assets/images | Folders containing image files |
| --output-dir | -O | lib/generated | Output folder stores for the generated file |
| --output-file | -o | images_keys.images_keys.dart | Output file name |

See [example](example/README.md) for more details.