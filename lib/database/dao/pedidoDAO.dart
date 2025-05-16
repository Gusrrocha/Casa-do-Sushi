import 'package:casadosushi/database/database_helper.dart';
import 'package:casadosushi/models/pedido.dart';
import 'package:sqflite/sqflite.dart';


class PedidoDAO{
  Future<Database> get _db async => await DatabaseHelper().database;

  Future<Pedido> createPedido(Pedido pedido) async {
    final db = await _db;
    final id = await db.insert('Pedido', pedido.toJson());
    return pedido.copyWith(id: id);
  }

  Future<List<Pedido>> listPedido() async{
    final db = await _db;
    final list = await db.query('Pedido');
    return list.map((json) => Pedido.fromJson(json)).toList();
  }

  Future<void> deletePedido(int id) async {
    final db = await _db;
    await db.delete('Pedido', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updatePedido(Pedido pedido, int id) async{
    final db = await _db;
    await db.update('Pedido', pedido.toJson(), where: 'id = ?', whereArgs: [id]);
  }
}