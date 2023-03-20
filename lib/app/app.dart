import 'package:answer/app/core/app/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_translation.dart';
import 'core/app/app_manager.dart';
import 'core/app/app_progress_hud.dart';
import 'core/binding/initial_binding.dart';
import 'routes/app_pages.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final AppTheme theme = AppTheme();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: theme.light,
      darkTheme: theme.dark,
      themeMode: AppManager.to.themeMode,
      initialRoute: AppPages.initial,
      initialBinding: InitialBinding(),
      getPages: AppPages.routes,
      fallbackLocale: const Locale('en', 'US'),
      locale: Get.deviceLocale ?? const Locale('en', 'US'),
      // locale: AppManager.to.locale ?? const Locale('zh', 'CN'),
      translations: AppTranslation(),
      builder: AppProgressHud.init(),
      debugShowCheckedModeBanner: false,
    );
  }
}
