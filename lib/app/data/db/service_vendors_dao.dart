import 'dart:convert';

import 'package:answer/app/data/db/service_providers_dao.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

import '../../providers/service_vendor.dart';

class ServiceVendorsDao {
  static const table = 'service_vendors';

  final Database db;
  ServiceVendorsDao(this.db);

  static Future<void> onCreate(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${ServiceVendorsDao.table} (
        id TEXT NOT NULL PRIMARY KEY,
        name TEXT,
        avatar TEXT,
        api_url TEXT,
        edit_api_url TEXT,
        official_url TEXT,
        help TEXT,
        help_url TEXT,
        hello TEXT,
        timeout INTEGER,
        block INTEGER DEFAULT 0
      );
    ''');
  }

  static Future<void> onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    final string = await rootBundle.loadString(
      'assets/files/service_vendors.json',
    );
    final List list = json.decode(utf8.decode(base64.decode(string)));
    for (final map in list) {
      if (oldVersion < 3) {
        final first = (await db.rawQuery(
          'SELECT id, edit_api_url FROM ${ServiceProvidersDao.table} WHERE id = ?',
          [map['id']],
        ))
            .firstOrNull;
        if (first != null) {
          map['edit_api_url'] = first['edit_api_url'];
        }
      }
      await db.insert(
        table,
        map,
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }

  Future<Iterable<ServiceVendor>> getAll() async {
    return (await db.query(table)).map(ServiceVendor.fromJson);
  }

  Future<ServiceVendor?> get({required String id}) async {
    return (await db.query(table, where: 'id = ?', whereArgs: [id]))
        .map(ServiceVendor.fromJson)
        .firstOrNull;
  }

  Future<void> create(ServiceVendor object) async {
    final json = object.toJson();
    json.remove('tokens');
    await db.insert(
      table,
      json,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
