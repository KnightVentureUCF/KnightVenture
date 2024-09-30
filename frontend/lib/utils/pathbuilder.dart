import 'package:frontend/constants.dart' show hosting, port;

String buildPath(String route) {
  const env = String.fromEnvironment('ENVIRONMENT');

  if (env == 'development') {
    return 'http://localhost:$port/$route';
  } else {
    return '$hosting/$route';
  }
}
