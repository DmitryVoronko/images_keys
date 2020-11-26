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

bool _isHelpCommand(List<String> args) =>
    args.length == 1 && (args[0] == '--help' || args[0] == '-h');

void _printHelperDisplay() {
  final ArgParser parser = _generateArgParser(null);
  print(parser.usage);
}

GenerateOptions _generateOption(List<String> args) {
  final GenerateOptions generateOptions = GenerateOptions();
  final ArgParser parser = _generateArgParser(generateOptions);
  parser.parse(args);
  return generateOptions;
}

ArgParser _generateArgParser(GenerateOptions generateOptions) {
  final ArgParser parser = ArgParser();

  parser.addMultiOption(
    'source-dir',
    abbr: 'S',
    defaultsTo: ['assets/images', 'assets/icons'],
    callback: (List<String> x) => generateOptions.sourceDirs = x,
    help: 'Folders containing image files',
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
  List<String> sourceDirs;
  String outputDir;
  String outputFile;

  @override
  String toString() =>
      'GenerateOptions{sourceDirs: $sourceDirs, outputDir: $outputDir,'
      ' outputFile: $outputFile}';
}

void handleLangFiles(GenerateOptions options) async {
  final Directory current = Directory.current;
  final List<Directory> sourcePaths = options.sourceDirs
      .map((uri) => Directory.fromUri(Uri.parse(uri)))
      .map((source) => Directory(path.join(current.path, source.path)))
      .toList();

  final Directory output = Directory.fromUri(Uri.parse(options.outputDir));
  final Directory outputPath =
      Directory(path.join(current.path, output.path, options.outputFile));

  if (!sourcePaths.every((element) => element.existsSync())) {
    final nonexistentSourcePaths =
        sourcePaths.where((element) => !element.existsSync());
    printError('Some source paths does not exist: $nonexistentSourcePaths');
    return;
  }

  final List<FileSystemEntity> files = await dirsContents(sourcePaths);

  if (files.isNotEmpty) {
    generateFile(files, outputPath);
  } else {
    printError('Source path empty');
  }
}

Future<List<FileSystemEntity>> dirsContents(List<Directory> dirs) async => dirs
    .map((dir) => dir.listSync(recursive: false))
    .expand((element) => element)
    .where((element) => FileSystemEntity.isFileSync(element.path))
    .toList();

void generateFile(List<FileSystemEntity> files, Directory outputPath) async {
  final File generatedFile = File(outputPath.path);
  if (!generatedFile.existsSync()) {
    generatedFile.createSync(recursive: true);
  }

  final StringBuffer classBuilder = StringBuffer();

  await _writeKeys(classBuilder, files);

  generatedFile.writeAsStringSync(classBuilder.toString());

  printInfo('All done! File generated in ${outputPath.path}');
}

Future _writeKeys(
  StringBuffer classBuilder,
  List<FileSystemEntity> files,
) async {
  classBuilder.writeln(
      '// DO NOT EDIT. This is code generated via package:images_keys/generate.dart');
  classBuilder.writeln('abstract class ImagesKeys {');

  final keys = files.map((element) {
    final keyName = path.basename(element.path).replaceAll('.', '_');
    final keyValue = "'${path.relative(element.path)}'";
    return '  static const $keyName = $keyValue;';
  });

  classBuilder.writeAll(keys, '\n');
  classBuilder.write('\n');

  classBuilder.writeln('}');
}

void printInfo(String info) {
  print('\u001b[32m image key gen: $info\u001b[0m');
}

void printError(String error) {
  print('\u001b[31m[ERROR] image key gen: $error\u001b[0m');
}
