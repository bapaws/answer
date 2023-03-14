import 'dart:math';

import 'package:flutter/foundation.dart';

class AppUuid {
  AppUuid();

  @override
  String toString() =>
      shortHash(this) + Random().nextInt(0xFFFFFF).toRadixString(16);

  static String get value => AppUuid().toString();
}
