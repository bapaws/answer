import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app_controller_mixin.dart';

class AppManager extends GetxController with AppControllerMixin {
  static AppManager get to => Get.find();
  static const String _appManagerBox = 'AppManager';

  late final Box _box;

  static const _themeModeKey = '_themeMode';
  ThemeMode? _themeMode;
  ThemeMode get themeMode => _themeMode ?? ThemeMode.system;
  set themeMode(ThemeMode themeMode) {
    if (_themeMode == themeMode) return;
    _themeMode = themeMode;
    Get.changeThemeMode(themeMode);

    _box.put(_themeModeKey, themeMode.index);
  }

  bool get isLightMode =>
      themeMode == ThemeMode.light ||
      (themeMode == ThemeMode.system &&
          SchedulerBinding.instance.window.platformBrightness ==
              Brightness.light);

  static const _localeKey = '_locale';
  Locale? _locale;
  Locale? get locale => _locale;
  set locale(Locale? locale) {
    if (_locale == locale) return;
    _locale = locale;

    if (locale == null) {
      Get.updateLocale(
        Get.deviceLocale ?? const Locale('zh', 'CN'),
      );
      _box.delete(_localeKey);
    } else {
      Get.updateLocale(locale);
      _box.put(
        _localeKey,
        '${locale.languageCode}&${locale.countryCode ?? ''}',
      );
    }
  }

  final Map<String, dynamic> _map = {};
  T? get<T>({required String key}) {
    final value = _map[key];
    if (value != null) return value;
    return _map[key] = _box.get(key);
  }

  void set<T>({required String key, T? value}) {
    final oldValue = _map[key];
    if (oldValue == value) return;
    if (value == null) {
      _map.remove(key);
      _box.delete(key);
    } else {
      _map[key] = value;
      _box.put(key, value);
    }
    update();
  }

  AppManager._({required Box box}) : _box = box;

  static Future<void> initialize() async {
    await Hive.initFlutter();

    final box = await Hive.openBox(_appManagerBox);
    final manager = AppManager._(box: box);
    Get.put(manager);
  }

  @override
  void onInit() {
    final int? index = _box.get(_themeModeKey);
    if (index != null) {
      _themeMode = ThemeMode.values[index];
    }

    final String? languageCode = _box.get(_localeKey);
    if (languageCode != null) {
      final codes = languageCode.split('&');
      _locale = Locale.fromSubtags(
        languageCode: codes[0],
        countryCode: codes[1].isEmpty ? null : codes[1],
      );
    }

    super.onInit();
  }
}
