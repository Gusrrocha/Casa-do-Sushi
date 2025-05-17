import 'package:casadosushi/models/produto.dart';

class Item {
  final int? id;
  final int? idPedido;
  final int idProduto;
  int quantidade;
  double? valor;
  Produto? produto;

  Item({
    this.id,
    this.idPedido,
    required this.idProduto,
    this.quantidade = 1,
    this.valor,
    this.produto
  });

  static Item fromJson(Map<String, dynamic> json) => Item(
    id: json['id'] as int?,
    idPedido: json['idPedido'] as int,
    idProduto: json['idProduto'] as int,
    quantidade: json['quantidade'] as int,
  );
  
  Map<String, dynamic> toJson() =>{
    'id': id,
    'idPedido': idPedido,
    'idProduto': idProduto,
    'quantidade': quantidade,
  };

  Item copyWith({
    int? id,
    int? idPedido,
    int? idProduto,
    int? quantidade,
  }) => 
  Item(
    id: id ?? this.id,
    idPedido: idPedido ?? this.idPedido,
    idProduto: idProduto ?? this.idProduto,
    quantidade: quantidade ?? this.quantidade,
  );
}