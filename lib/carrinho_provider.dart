
import 'package:casadosushi/models/item.dart';
import 'package:casadosushi/models/produto.dart';
import 'package:flutter/foundation.dart';

class CarrinhoProvider with ChangeNotifier{
  final List<Item> _carrinho = [];

  List<Item> get carrinho => _carrinho;

  void addItem(Produto produto, {int quantidade = 1}) {
    final index = _carrinho.indexWhere((item) => item.produto?.id == produto.id);
    if (index >= 0) {
      _carrinho[index].quantidade += quantidade;
    } else {
      _carrinho.add(Item(produto: produto, idProduto: produto.id!, valor: produto.value, quantidade: quantidade));
    }
    notifyListeners();
  }

  void removeItem(Produto produto) {
    final index = _carrinho.indexWhere((item) => item.produto?.id == produto.id);
    if (index >= 0) {
      _carrinho[index].quantidade--;
      if (_carrinho[index].quantidade <= 0) {
        _carrinho.removeAt(index);
      }
    }

    notifyListeners();
  }

  void clearCarrinho() {
    _carrinho.clear();
    notifyListeners();
  }

  double get total {
    double total = 0;
    for (var item in _carrinho) {
      total += item.valor! * item.quantidade;
    }
    return total;
  }
}

