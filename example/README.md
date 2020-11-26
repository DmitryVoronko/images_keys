# example

An example Flutter project of using images_keys.

## example/assets/images/logo_dart.png
![](assets/images/logo_dart.png)

## example/pubspec.yaml

```yaml
name: example
description: An example Flutter project of using images_keys.

publish_to: 'none' # Remove this line if you wish to publish to pub.dev

version: 1.0.0+1

environment:
  sdk: ">=2.7.0 <3.0.0"

dependencies:
  flutter:
    sdk: flutter

  images_keys:
    path: ../

dev_dependencies:
  flutter_test:
    sdk: flutter

flutter:
  uses-material-design: true

  assets:
    - assets/images/
```

## example/generate_image_assets_keys.sh

```bash
flutter pub run images_keys:images_keys -S assets/images -O lib/res/images -o images_keys.images_keys.dart
```

## example/lib/res/images/images_keys.images_keys.dart

```dart
// DO NOT EDIT. This is code generated via package:images_keys/generate.dart
abstract class  ImagesKeys {
  static const logo_dart_png = 'assets/images/logo_dart.png';

}

```

## example/lib/main.dart

```dart
import 'package:example/res/images/images_keys.images_keys.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(ImagesKeys.logo_dart_png),
          ],
        ),
      ),
    );
  }
}

```