import 'dart:async';

import 'package:answer/app/data/db/service_providers_dao.dart';
import 'package:answer/app/data/db/service_tokens_dao.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'conversations_dao.dart';
import 'messages_dao.dart';

class AppDatabase {
  static const defaultLimit = 16;

  static final AppDatabase instance = AppDatabase._internal();
  AppDatabase._internal();

  late final Database database;

  late final ConversationsDao conversationsDao = ConversationsDao(database);
  late final MessagesDao messagesDao = MessagesDao(database);
  late final ServiceProvidersDao serviceProvidersDao =
      ServiceProvidersDao(database);
  late final ServiceTokensDao serviceTokensDao = ServiceTokensDao(database);

  static Future<void> initialize({
    required String dbName,
  }) async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, dbName);

    if (kDebugMode) {
      print(path);
    }

    instance.database = await openDatabase(
      path,
      onCreate: instance._onCreate,
      onUpgrade: instance._onUpgrade,
      version: 3,
    );
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    ConversationsDao.onCreate(db);
    ServiceProvidersDao.onCreate(db);
    ServiceTokensDao.onCreate(db);
  }

  FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) {
    ServiceProvidersDao.onUpgrade(db, oldVersion, newVersion);
    MessagesDao.onUpgrade(db, oldVersion, newVersion);
  }
}
