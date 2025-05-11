class Item {
  final int? id;
  final int idPedido;
  final int idProduto;
  final int quantidade;
  final int valor;

  const Item({
    this.id,
    required this.idPedido,
    required this.idProduto,
    required this.quantidade,
    required this.valor
  });

  static Item fromJson(Map<String, dynamic> json) => Item(
    id: json['id'] as int?,
    idPedido: json['idPedido'] as int,
    idProduto: json['idProduto'] as int,
    quantidade: json['quantidade'] as int,
    valor: json['valor'] as int
  );
  
  Map<String, dynamic> toJson() =>{
    'id': id,
    'idPedido': idPedido,
    'idProduto': idProduto,
    'quantidade': quantidade,
    'valor': valor
  };

  Item copyWith({
    int? id,
    int? idPedido,
    int? idProduto,
    int? quantidade,
    int? valor
  }) => 
  Item(
    id: id ?? this.id,
    idPedido: idPedido ?? this.idPedido,
    idProduto: idProduto ?? this.idProduto,
    quantidade: quantidade ?? this.quantidade,
    valor: valor ?? this.valor
  );
}