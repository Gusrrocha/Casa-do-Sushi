import 'package:casadosushi/models/item.dart';

class Pedido{
  final int? id;
  final int idUsuario;
  final List<Item> listaItens;
  final DateTime data;

  const Pedido({
    this.id,
    required this.idUsuario,
    this.listaItens = const [],
    required this.data
  });



  static Pedido fromJson(Map<String, dynamic> json) => Pedido(
    id: json['id'] as int?,
    idUsuario: json['idUsuario'] as int,
    listaItens: json['listaItens'] as List<Item>,
    data: json['data'] as DateTime,
  );

  Map<String, dynamic> toJson() =>{
    'id': id,
    'idUsuario': idUsuario,
    'listaItens': listaItens,
    'data': data,
  };

  Pedido copyWith({
    int? id,
    int? idUsuario,
    List<Item>? listaItens,
    DateTime? data,
  }) => 
  Pedido(
    id: id ?? this.id,
    idUsuario: idUsuario ?? this.idUsuario,
    listaItens: listaItens ?? this.listaItens,
    data: data ?? this.data
  );
}

