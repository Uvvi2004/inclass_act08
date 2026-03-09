import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/folder.dart';

class FolderRepository {

  Future<int> insertFolder(Folder folder) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert('folders', folder.toMap());
  }

  Future<List<Folder>> getFolders() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query('folders');

    return result.map((map) => Folder.fromMap(map)).toList();
  }

  Future<int> deleteFolder(int id) async {
    final db = await DatabaseHelper.instance.database;
    return await db.delete(
      'folders',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}