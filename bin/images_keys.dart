import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart' as path;

void main(List<String> args) {
  if (_isHelpCommand(args)) {
    _printHelperDisplay();
  } else {
    handleLangFiles(_generateOption(args));
  }
}

bool _isHelpCommand(List<String> args) {
  return args.length == 1 && (args[0] == '--help' || args[0] == '-h');
}

void _printHelperDisplay() {
  var parser = _generateArgParser(null);
  print(parser.usage);
}

GenerateOptions _generateOption(List<String> args) {
  var generateOptions = GenerateOptions();
  var parser = _generateArgParser(generateOptions);
  parser.parse(args);
  return generateOptions;
}

ArgParser _generateArgParser(GenerateOptions generateOptions) {
  var parser = ArgParser();

  parser.addOption(
    'source-dir',
    abbr: 'S',
    defaultsTo: 'assets/images',
    callback: (String x) => generateOptions.sourceDir = x,
    help: 'Folder containing image files',
  );

  parser.addOption(
    'output-dir',
    abbr: 'O',
    defaultsTo: 'lib/generated',
    callback: (String x) => generateOptions.outputDir = x,
    help: 'Output folder stores for the generated file',
  );

  parser.addOption(
    'output-file',
    abbr: 'o',
    defaultsTo: 'images_keys.images_keys.dart',
    callback: (String x) => generateOptions.outputFile = x,
    help: 'Output file name',
  );

  return parser;
}

class GenerateOptions {
  String sourceDir;
  String outputDir;
  String outputFile;

  @override
  String toString() =>
      'GenerateOptions{sourceDir: $sourceDir, outputDir: $outputDir, outputFile: $outputFile}';
}

void handleLangFiles(GenerateOptions options) async {
  final current = Directory.current;
  final source = Directory.fromUri(Uri.parse(options.sourceDir));
  final output = Directory.fromUri(Uri.parse(options.outputDir));
  final sourcePath = Directory(path.join(current.path, source.path));
  final outputPath =
      Directory(path.join(current.path, output.path, options.outputFile));

  if (!await sourcePath.exists()) {
    printError('Source path does not exist');
    return;
  }

  final files = await dirContents(sourcePath);

  if (files.isNotEmpty) {
    generateFile(files, outputPath);
  } else {
    printError('Source path empty');
  }
}

Future<List<FileSystemEntity>> dirContents(Directory dir) async => dir
    .listSync(recursive: false)
    .where((element) => FileSystemEntity.isFileSync(element.path))
    .toList();

void generateFile(List<FileSystemEntity> files, Directory outputPath) async {
  var generatedFile = File(outputPath.path);
  if (!generatedFile.existsSync()) {
    generatedFile.createSync(recursive: true);
  }

  var classBuilder = StringBuffer();

  await _writeKeys(classBuilder, files);

  classBuilder.writeln('}');
  generatedFile.writeAsStringSync(classBuilder.toString());

  printInfo('All done! File generated in ${outputPath.path}');
}

Future _writeKeys(
  StringBuffer classBuilder,
  List<FileSystemEntity> files,
) async {
  var file = '''
// DO NOT EDIT. This is code generated via package:images_keys/generate.dart
abstract class  ImagesKeys {
''';

  files.forEach((element) {
    final keyName = path.basename(element.path).replaceAll('.', '_');
    final keyValue = "'${path.relative(element.path)}'";
    file += '  static const ${keyName} = ${keyValue};\n';
  });

  classBuilder.writeln(file);
}

void printInfo(String info) {
  print('\u001b[32m image key gen: $info\u001b[0m');
}

void printError(String error) {
  print('\u001b[31m[ERROR] image key gen: $error\u001b[0m');
}
