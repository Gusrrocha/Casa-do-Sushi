import 'package:casadosushi/models/item.dart';

class Pedido{
  final int? id;
  final int idUsuario;
  List<Item> listaItens;
  final String data;
  final double? valor;


  Pedido({
    this.id,
    required this.idUsuario,
    this.listaItens = const [],
    required this.data,
    required this.valor
  });



  static Pedido fromJson(Map<String, dynamic> json) => Pedido(
    id: json['id'] as int?,
    idUsuario: json['idUsuario'] as int,
    data: json['data'] as String,
    valor: json['valor'] as double?
  );

  Map<String, dynamic> toJson() =>{
    'id': id,
    'idUsuario': idUsuario,
    'data': data,
    'valor': valor
  };

  Pedido copyWith({
    int? id,
    int? idUsuario,
    List<Item>? listaItens,
    String? data,
    double? valor
  }) => 
  Pedido(
    id: id ?? this.id,
    idUsuario: idUsuario ?? this.idUsuario,
    listaItens: listaItens ?? this.listaItens,
    data: data ?? this.data,
    valor: valor ?? this.valor
  );
}

