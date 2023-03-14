import 'package:answer/app/data/models/conversation.dart';
import 'package:sqflite/sqflite.dart';

class ConversationsDao {
  static const table = 'conversations';

  final Database db;
  ConversationsDao(this.db);

  static Future<void> onCreate(Database db) => db.execute('''
      CREATE TABLE $table (
        id TEXT NOT NULL PRIMARY KEY,
        name TEXT,
        edit_name TEXT,
        group_id INTEGER,
        message_version INTEGER DEFAULT 0
      );
    ''');

  Future<Iterable<Conversation>> getAll({required int groupId}) async {
    return (await db.query(
      table,
      where: 'group_id = ?',
      whereArgs: [groupId],
    ))
        .map((e) => Conversation.fromJson(e));
  }

  Future<int> create(Conversation chat) async {
    return await db.insert(
      table,
      chat.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> update(Conversation chat) async {
    return await db.update(
      table,
      chat.toJson(),
      where: 'id = ?',
      whereArgs: [chat.id],
    );
  }

  Future<void> delete(String id) async {
    await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
