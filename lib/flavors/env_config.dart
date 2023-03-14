import 'dart:io';

class EnvConfig {
  final String appName;
  final String dbName;
  final bool shouldCollectCrashLog;
  final HttpOverrides? httpOverrides;
  final String? openAIApiKey;

  EnvConfig({
    required this.appName,
    required this.dbName,
    this.shouldCollectCrashLog = false,
    this.httpOverrides,
    this.openAIApiKey,
  });
}
