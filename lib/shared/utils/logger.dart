import 'dart:convert';
import 'dart:developer' as developer;

import 'package:logger/logger.dart';

final _logger = Logger(
  printer: PrettyPrinter(
    colors: const bool.fromEnvironment('logger_color', defaultValue: false),
    dateTimeFormat: DateTimeFormat.dateAndTime,
  ),
  output: Output(),
);

Logger get logger => _logger;

void loggerJson(Object? json, [String? message]) {
  try {
    final formattedJson = const JsonEncoder.withIndent('  ').convert(json);
    final logMessage = message != null
        ? '$message:\n$formattedJson'
        : formattedJson;
    logger.d(logMessage);
  } catch (e) {
    logger.d('JSON 파싱 에러: $e\n원본: $json');
  }
}

class Output extends LogOutput {
  @override
  void output(OutputEvent event) {
    developer.log(
      event.lines.join('\n'),
      name: 'Logger.${event.level.name[0]}',
    );
  }
}
