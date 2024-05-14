import 'package:frontend/constants.dart' show appName, hosting, port;

String buildPath(String route) {
  const env = String.fromEnvironment('ENVIRONMENT');

  if (env == 'production') {
    return 'https://$appName.$hosting/$route';
  } else {
    return 'http://localhost:$port/$route';
  }
}
