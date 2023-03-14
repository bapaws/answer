import 'dart:io';

class AppHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..connectionTimeout = const Duration(seconds: 15)
      ..maxConnectionsPerHost = 5
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true)
      // ..findProxy = ((url) => 'PROXY localhost:1081')
      ..findProxy = (url) => HttpClient.findProxyFromEnvironment(
            url,
            environment: {
              "http_proxy": "http://127.0.0.1:7890",
              "https_proxy": "http://127.0.0.1:7890",
              "ALL_PROXY": "socks5://127.0.0.1:7890",
              "HTTP_PROXY": "http://127.0.0.1:7890",
              "HTTPS_PROXY": "http://127.0.0.1:7890",
            },
          );
    // ..badCertificateCallback =
    //     ((X509Certificate cert, String host, int port) => true);
  }
}
