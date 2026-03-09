import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/card_model.dart';

class CardRepository {

  Future<int> insertCard(CardModel card) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert('cards', card.toMap());
  }

  Future<List<CardModel>> getCardsByFolder(int folderId) async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.query(
      'cards',
      where: 'folder_id = ?',
      whereArgs: [folderId],
    );

    return result.map((map) => CardModel.fromMap(map)).toList();
  }

  Future<int> deleteCard(int id) async {
    final db = await DatabaseHelper.instance.database;

    return await db.delete(
      'cards',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}