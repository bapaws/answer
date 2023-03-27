import 'dart:convert';

import 'package:answer/app/data/models/request_parameter.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

class RequestParametersDao {
  static const table = 'request_parameters';

  final Database db;
  RequestParametersDao(this.db);

  static Future<void> onCreate(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${RequestParametersDao.table} (
        key TEXT NOT NULL,
        value TEXT,
        value_type INTEGER,
        choices TEXT,
        desc TEXT,
        required INTEGER DEFAULT 0,
        vendor_id TEXT,
        PRIMARY KEY (key, vendor_id)
      );
    ''');

    // format data
    final string = await rootBundle.loadString(
      'assets/files/request_parameters.json',
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

  static Future<void> onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    final string = await rootBundle.loadString(
      'assets/files/request_parameters.json',
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

  Future<Iterable<RequestParameter>> getAll() async {
    List<Map<String, Object?>> list = await db.rawQuery(
      'SELECT * FROM $table',
    );
    return list.map((e) => RequestParameter.fromJson(e));
  }

  Future<int> create(RequestParameter parameter) async {
    return await db.insert(
      table,
      parameter.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> delete(RequestParameter parameter) async {
    return await db.delete(
      table,
      where: 'key = ? AND vendor_id = ?',
      whereArgs: [parameter.key, parameter.vendorId],
    );
  }
}
