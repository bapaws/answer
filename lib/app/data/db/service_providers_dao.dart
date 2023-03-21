import 'package:answer/app/data/db/service_vendors_dao.dart';
import 'package:answer/app/providers/service_provider_manager.dart';
import 'package:collection/collection.dart';
import 'package:sqflite/sqflite.dart';

import '../../providers/service_provider.dart';

class ServiceProvidersDao {
  static const table = 'service_providers';

  final Database db;
  ServiceProvidersDao(this.db);

  static Future<void> onCreate(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${ServiceProvidersDao.table} (
        id TEXT NOT NULL PRIMARY KEY,
        name TEXT,
        vendor_id TEXT,
        avatar TEXT,
        desc TEXT,
        group_id INTEGER,
        hello TEXT,
        block INTEGER DEFAULT 0
      );
    ''');
  }

  static Future<void> onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    // new version is 2
    final hello = await db.rawQuery(
      'SELECT * FROM sqlite_master WHERE name="$table" AND sql LIKE "%hello%";',
    );
    if (hello.isEmpty) {
      await db.execute('ALTER TABLE $table ADD COLUMN hello TEXT;');
    }
    final desc = await db.rawQuery(
      'SELECT * FROM sqlite_master WHERE name="$table" AND sql LIKE "%desc%";',
    );
    if (desc.isEmpty) {
      await db.execute('ALTER TABLE $table ADD COLUMN desc TEXT;');
    }
    // VERSION 3
    final vendorId = await db.rawQuery(
      'SELECT * FROM sqlite_master WHERE name="$table" AND sql LIKE "%vendor_id%";',
    );
    if (vendorId.isEmpty) {
      await db.execute('ALTER TABLE $table ADD COLUMN vendor_id TEXT;');
      await db.execute('ALTER TABLE $table ADD COLUMN model TEXT;');

      final list = await db.rawQuery(
        'SELECT id, edit_api_url FROM ${ServiceProvidersDao.table}',
      );
      if (list.isNotEmpty) {
        final json = ServiceProviderManager.instance.vendors.first.toJson();
        json['edit_api_url'] = list.first['edit_api_url'];
        await db.insert(ServiceVendorsDao.table, json);
      }
    }
  }

  Future<List<Map<String, Object?>>> getAll({required int groupId}) async {
    return (await db.query(table, where: 'group_id = ?', whereArgs: [groupId]));
  }

  Future<Map<String, dynamic>?> get({required String id}) async {
    return (await db.query(table, where: 'id = ?', whereArgs: [id]))
        .firstOrNull;
  }

  Future<void> create(ServiceProvider provider) async {
    final json = provider.toJson();
    json.remove('tokens');
    await db.insert(
      table,
      json,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
