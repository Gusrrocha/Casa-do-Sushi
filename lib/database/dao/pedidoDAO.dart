import 'package:casadosushi/database/database_helper.dart';
import 'package:casadosushi/models/item.dart';
import 'package:casadosushi/models/pedido.dart';
import 'package:casadosushi/models/produto.dart';
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

  Future<List<Pedido>> getAllPedidosByUserId(int id) async{
    final db = await _db;
    final result = await db.query('Pedido', where: 'idUsuario = ?', whereArgs: [id]);
    final lista = result.map((json) => Pedido.fromJson(json)).toList();
    for (var pedido in lista) {
      final itemMaps = await db.query('Item', where: 'idPedido = ?', whereArgs: [pedido.id]);
      pedido.listaItens = itemMaps.map((json) => Item.fromJson(json)).toList();
      for (var item in pedido.listaItens) {
        final produtoMaps = await db.query('Produto', where: '_id = ?', whereArgs: [item.idProduto]);
        item.produto = produtoMaps.map((json) => Produto.fromJson(json)).first;
      }
    }
    return lista;
  }
}