const appName = 'TBD';
const hosting = 'TBD.com';
const port = '3000';

String buildPath(String route) {
  const env = String.fromEnvironment('ENVIRONMENT');

  if (env == 'production') {
    return 'https://$appName.$hosting/$route';
  } else {
    return 'http://localhost:$port/$route';
  }
}
