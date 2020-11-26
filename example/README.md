# example

An example Flutter project of using images_keys.

## One image asset folder

If you have such package structure:

```
project
├──assets
│  └── images
│      ├── logo_dart.png
│      │   ...
├──lib
│   │   ...
│  ...
```

You can simply run command:

```bash
flutter pub run images_keys:images_keys \
-S assets/images \
-O lib/res/images \
-o images_keys.images_keys.dart
```

Then you receive:

```dart
// DO NOT EDIT. This is code generated via package:images_keys/generate.dart
abstract class ImagesKeys {
  static const logo_dart_png = 'assets/images/logo_dart.png';
}
```

Past import:
```dart
import 'package:example/res/images/images_keys.images_keys.dart';
```

Use generated keys:

```dart
Image.asset(ImagesKeys.logo_dart_png)
```

## Multiple image assets folders

If you have multiple image source folders:

```
project
├──assets
│  ├── images
│  │   ├── logo_dart.png
│  │   │   ...
│  │
│  └── icons 
│      ├── baseline_sentiment.png
│      │   ...
│
├──lib
│   │   ...
│  ...
```

You can simply pass them all in command:

```bash
flutter pub run images_keys:images_keys \
-S assets/images \
-S assets/icons \
-O lib/res/images \
-o images_keys.images_keys.dart
```

All of images assets will be included in ImagesKeys class:

```dart
// DO NOT EDIT. This is code generated via package:images_keys/generate.dart
abstract class ImagesKeys {
  static const logo_dart_png = 'assets/images/logo_dart.png';
  static const baseline_sentiment_png = 'assets/icons/baseline_sentiment.png';
}
```