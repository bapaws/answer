import 'package:fluttertoast/fluttertoast.dart';

abstract class AppToast {
  static Future<void> show({required String msg}) async {
    await Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.CENTER,
    );
  }
}
