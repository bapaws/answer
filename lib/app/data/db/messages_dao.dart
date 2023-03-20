import 'package:answer/app/data/db/conversations_dao.dart';
import 'package:sqflite/sqflite.dart';

import '../models/message.dart';

class MessagesDao {
  static const table = 'messages_';

  final Database db;
  MessagesDao(this.db);

  Future<void> onCreate({required String conversationId}) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $table$conversationId (
        id TEXT NOT NULL PRIMARY KEY,
        type INTEGER,
        from_type INTEGER,
        service_name TEXT,
        service_avatar TEXT,
        content TEXT,
        create_at DATETIME,
        request_message TEXT,
        quote_message TEXT,
        response_data TEXT,
        conversation_id TEXT REFERENCES ${ConversationsDao.table} (id),
        service_id TEXT
      );
    ''');
  }

  static Future<void> onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    // new version is 3
    final tables = await db.rawQuery(
      'SELECT * FROM sqlite_master WHERE name LIKE "$table%";',
    );
    for (final item in tables) {
      final tableName = item['name'];
      final quoteMessage = await db.rawQuery(
        'SELECT * FROM sqlite_master WHERE name LIKE "$tableName" AND sql LIKE "%quote_message%";',
      );
      if (quoteMessage.isEmpty) {
        await db.execute(
          'ALTER TABLE $tableName ADD COLUMN quote_message TEXT;',
        );
      }
    }
  }

  Future<void> dropTable({required String conversationId}) {
    return db.execute('DROP TABLE $table$conversationId');
  }

  Future<Iterable<Message>> get({
    required String conversationId,
    String? serviceId,
    MessageType? type,
    int offset = 0,
    int limit = 16,
  }) async {
    return (await db.rawQuery(
      'SELECT * FROM $table$conversationId ${_buildWhere(
        serviceId: serviceId,
        type: type,
      )}ORDER BY create_at DESC LIMIT $limit OFFSET $offset',
    ))
        .map((e) => Message.fromJson(e));
  }

  String _buildWhere({
    String? serviceId,
    MessageType? type,
  }) {
    List<String> where = [];
    if (serviceId != null) {
      where.add('service_id = "$serviceId"');
    }
    if (type != null) {
      where.add('type = ${type.index}');
    }
    return where.isEmpty ? '' : 'WHERE ${where.join(' AND ')} ';
  }

  Future<int> create(Message message) async {
    return await db.insert('$table${message.conversationId}', message.toJson());
  }

  Future<int> delete(Message message) async {
    return await db.delete(
      '$table${message.conversationId}',
      where: 'id = ?',
      whereArgs: [message.id],
    );
  }
}
