import 'package:answer/app/data/models/group.dart';
import 'package:sqflite/sqflite.dart';

class GroupsDao {
  static const table = 'groups';

  final Database db;
  GroupsDao(this.db);

  Future<Iterable<Group>> getAll() async {
    return (await db.query(table)).map((e) => Group.fromJson(e));
  }

  Future<int> create(Group chat) async {
    return await db.insert(table, chat.toJson());
  }

  Future<int> update(Group chat) async {
    return await db.update(
      table,
      chat.toJson(),
      where: 'id = ?',
      whereArgs: [chat.id],
    );
  }
}
