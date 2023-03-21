import 'package:collection/collection.dart';
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
  ) async {}

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
