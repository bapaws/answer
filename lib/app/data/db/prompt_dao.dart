import 'package:answer/app/data/models/prompt.dart';
import 'package:collection/collection.dart';
import 'package:sqflite/sqflite.dart';

class PromptDao {
  static const table = 'prompts';

  final Database db;
  PromptDao(this.db);

  static Future<void> onCreate(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${PromptDao.table} (
        id TEXT NOT NULL PRIMARY KEY,
        title TEXT,
        content TEXT
      );
    ''');
  }

  static Future<void> onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {}

  Future<Iterable<Prompt>> getAll() async {
    List<Map<String, Object?>> list = await db.rawQuery(
      'SELECT * FROM $table',
    );
    return list.map((e) => Prompt.fromJson(e));
  }

  Future<Prompt?> get({required String id}) async {
    List<Map<String, Object?>> list = await db.rawQuery(
      'SELECT * FROM $table WHERE id = ?',
      [id],
    );
    return list.map((e) => Prompt.fromJson(e)).firstOrNull;
  }

  Future<int> create(Prompt object) async {
    return await db.insert(
      table,
      object.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> delete(Prompt object) async {
    return await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [object.id],
    );
  }
}
