import 'package:casadosushi/models/item.dart';

class Pedido{
  final int? id;
  final int idUsuario;
  List<Item> listaItens;
  final String data;
  final double? valor;
  final String paymentMethod;
  final String cep;
  final String rua;
  final String numero;
  final String? complemento;
  final String bairro;
  final String cidade;
  final String estado;
  int? parcelas;


  Pedido({
    this.id,
    required this.idUsuario,
    this.listaItens = const [],
    required this.data,
    required this.valor,
    required this.paymentMethod,
    this.parcelas,
    required this.cep,
    required this.rua,
    required this.numero,
    this.complemento,
    required this.bairro,
    required this.cidade,
    required this.estado,
  });



  static Pedido fromJson(Map<String, dynamic> json) => Pedido(
    id: json['id'] as int?,
    idUsuario: json['idUsuario'] as int,
    data: json['data'] as String,
    valor: json['valor'] as double?,
    paymentMethod: json['paymentMethod'] as String,
    parcelas: json['parcelas'] as int?,
    cep: json['cep'] as String,
    rua: json['rua'] as String,
    numero: json['numero'] as String,
    complemento: json['complemento'] as String,
    bairro: json['bairro'] as String,
    cidade: json['cidade'] as String,
    estado: json['estado'] as String
  );

  Map<String, dynamic> toJson() =>{
    'id': id,
    'idUsuario': idUsuario,
    'data': data,
    'valor': valor,
    'paymentMethod': paymentMethod,
    'parcelas': parcelas,
    'cep': cep,
    'rua': rua,
    'numero': numero,
    'complemento': complemento,
    'bairro': bairro,
    'cidade': cidade,
    'estado': estado
  };

  Pedido copyWith({
    int? id,
    int? idUsuario,
    List<Item>? listaItens,
    String? data,
    double? valor,
    String? paymentMethod,
    int? parcelas,
    String? cep,
    String? rua,
    String? numero,
    String? complemento,
    String? bairro,
    String? cidade,
    String? estado
  }) => 
  Pedido(
    id: id ?? this.id,
    idUsuario: idUsuario ?? this.idUsuario,
    listaItens: listaItens ?? this.listaItens,
    data: data ?? this.data,
    valor: valor ?? this.valor,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    parcelas: parcelas ?? this.parcelas,
    cep: cep ?? this.cep,
    rua: rua ?? this.rua,
    numero: numero ?? this.numero,
    complemento: complemento ?? this.complemento,
    bairro: bairro ?? this.bairro,
    cidade: cidade ?? this.cidade,
    estado: estado ?? this.estado
  );
}

