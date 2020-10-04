import 'package:logger/logger.dart';
import 'package:world_wanders/utils/log_printer.dart';

Logger getLogger(String className) {
  return Logger(printer: SimpleLogPrinter(className));
}