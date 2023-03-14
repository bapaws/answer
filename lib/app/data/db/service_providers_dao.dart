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
        avatar TEXT,
        desc TEXT,
        api_url TEXT,
        edit_api_url TEXT,
        official_url TEXT,
        group_id INTEGER,
        help TEXT,
        help_url TEXT,
        block INTEGER DEFAULT 0
      );
    ''');
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
