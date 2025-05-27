import 'package:casadosushi/database/dao/pedidoDAO.dart';
import 'package:casadosushi/models/pedido.dart';

class PedidoRepository {
  PedidoDAO pedidoDAO = PedidoDAO();

  Future<Pedido> createPedido(Pedido pedido) => pedidoDAO.createPedido(pedido);

  Future<List<Pedido>> listPedido() => pedidoDAO.listPedido();

  Future<void> deletePedido(int id) => pedidoDAO.deletePedido(id);

  Future<void> cancelarPedido(int id) => pedidoDAO.cancelarPedido(id);

  Future<void> updatePedido(Pedido pedido, int id) => pedidoDAO.updatePedido(pedido, id);

  Future<List<Pedido>> getAllPedidosByUserId(int id) => pedidoDAO.getAllPedidosByUserId(id);
}