import 'package:casadosushi/database/database_helper.dart';
import 'package:casadosushi/models/item.dart';
import 'package:sqflite/sqflite.dart';

class ItemDAO{
  Future<Database> get _db async => await DatabaseHelper().database;

  Future<Item> createItem(Item item) async{
    final db = await _db;
    final id = await db.insert('Item', item.toJson()); 
    return item.copyWith(id: id);
  }

  Future<void> deleteItem(int id) async{
    final db = await _db;
    await db.delete('Item', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateItem(Item item, int id) async{
    final db = await _db;
    await db.update('Item', item.toJson(), where: 'id = ?', whereArgs: [id]);
  }
}