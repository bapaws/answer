import '../../data/models/message.dart';

typedef AppPluginCallback = Future<void> Function(Message message);

abstract class AppPlugin {
  String get key;
  String get title;
  AppPluginCallback get onReceived;

  Future<void> send({required Message message});
}

abstract class AppServicePlugin {}
