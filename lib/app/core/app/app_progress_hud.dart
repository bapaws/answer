import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

abstract class AppProgressHud {
  static TransitionBuilder init() => EasyLoading.init();
  static Future<void> show() => EasyLoading.show(
        maskType: EasyLoadingMaskType.clear,
      );

  static Future<void> dismiss() => EasyLoading.dismiss();
}
