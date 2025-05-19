import 'package:casadosushi/database/dao/produtoDAO.dart';
import 'package:casadosushi/models/produto.dart';

class ProdutoRepository{
  final ProdutoDAO _produtoDAO = ProdutoDAO();

  Future<Produto> createProduto(Produto produto) => _produtoDAO.createProduto(produto);
  
  Future<List<Produto>> listProduto() => _produtoDAO.listProduto();

  Future<void> deleteProduto(int id) => _produtoDAO.deleteProduto(id);

  Future<void> updateProduto(Produto produto, int id) => _produtoDAO.updateProduto(produto, id);

  Future<Produto> getProdutoById(int id) => _produtoDAO.getProdutoById(id);
}