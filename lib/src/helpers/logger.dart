import 'package:logger/logger.dart';

class L {
  L._();

  static Logger _logger;
  static Logger get logger {
    if (_logger == null) {
      _logger = Logger(
        printer: PrettyPrinter(
          methodCount: 4,
        )
      );
    }

    return _logger;
  }

  static void debug(dynamic message) => logger.d(message);
  static void info(dynamic message) => logger.i(message);
  static void warning(dynamic message) => logger.w(message);
  static void error(dynamic message) => logger.e(message);
  static void verbose(dynamic message) => logger.v(message);
}
