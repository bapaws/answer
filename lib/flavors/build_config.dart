import 'package:answer/app/core/app/app_http.dart';
import 'package:answer/app/data/db/app_database.dart';

import '../app/core/app/app_manager.dart';
import 'env_config.dart';
import 'environment.dart';

class BuildConfig {
  late final Environment environment;
  late final EnvConfig config;
  bool _lock = false;

  static final BuildConfig instance = BuildConfig._internal();

  BuildConfig._internal();

  static Future<void> initialize({
    required Environment envType,
    required EnvConfig envConfig,
  }) async {
    if (instance._lock) return;

    instance.environment = envType;
    instance.config = envConfig;
    instance._lock = true;

    // if (envConfig.firebaseOptions != null &&
    //     instance.environment == Environment.dev) {
    //   await Firebase.initializeApp(
    //     options: envConfig.firebaseOptions,
    //   );
    // }
    await AppHttp.instantiate(
      httpOverrides: envConfig.httpOverrides,
    );
    await AppManager.initialize();
    await AppDatabase.initialize(
      dbName: envConfig.dbName,
    );
  }
}
