import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

import '../models/service_token.dart';

class ServiceTokensDao {
  static const table = 'service_tokens';

  final Database db;
  ServiceTokensDao(this.db);

  static Future<void> onCreate(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${ServiceTokensDao.table} (
        id TEXT NOT NULL PRIMARY KEY,
        name TEXT,
        value TEXT,
        service_provider_id TEXT
      );
    ''');
  }

  static Future<void> onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    final string = await rootBundle.loadString(
      'assets/files/service_tokens.json',
    );
    final List list = json.decode(utf8.decode(base64.decode(string)));
    final Batch batch = db.batch();
    for (final map in list) {
      batch.insert(
        table,
        map,
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
    await batch.commit();
  }

  Future<Iterable<ServiceToken>> getAll() async {
    List<Map<String, Object?>> list = await db.rawQuery(
      'SELECT * FROM $table',
    );
    return list.map((e) => ServiceToken.fromJson(e));
  }

  Future<String?> getValue({
    required String id,
  }) async {
    List<Map<String, Object?>> list = await db.rawQuery(
      'SELECT value FROM $table WHERE id = ?',
      [id],
    );
    final value = list.firstOrNull?['value'];
    if (value is String) return value;

    return null;
  }

  Future<int> create(ServiceToken token) async {
    return await db.insert(
      table,
      token.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> delete(ServiceToken token) async {
    return await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [token.id],
    );
  }
}
