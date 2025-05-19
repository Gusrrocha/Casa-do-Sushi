import 'package:casadosushi/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:casadosushi/models/produto.dart';

class ProdutoDAO {
  Future<Database> get _db async => await DatabaseHelper().database;

  Future<Produto> createProduto(Produto produto) async {
    final db = await _db;
    final id = await db.insert("Produto", produto.toJson());
    return produto.copyWith(id: id);
  }


  Future<List<Produto>> listProduto() async {
    final db = await _db;
    final list = await db.query('Produto');
    return list.map((json) => Produto.fromJson(json)).toList();
  }

  Future<void> deleteProduto(int id) async{
    final db = await _db;
    await db.delete("Produto", where: '_id = ?', whereArgs: [id]);
  }

  Future<void> updateProduto(Produto produto, int id) async{
    final db = await _db;
    await db.update('Produto', produto.toJson(), where: '_id = ?', whereArgs: [id]);
  } 
  
  Future<Produto> getProdutoById(int id) async {
    final db = await _db;
    final result = await db.query('Produto', where: '_id = ?', whereArgs: [id]);
    return Produto.fromJson(result.first);
  }
}
