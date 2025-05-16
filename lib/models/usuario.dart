class Usuario {
  final int? id;
  final String nome;
  final String telefone;
  final String email;
  final String senha;
  final String cpf;

  const Usuario({
    this.id,
    required this.nome,
    required this.telefone,
    required this.email,
    required this.senha,
    required this.cpf
  });

  static Usuario fromJson(Map<String, dynamic> json) => Usuario(
    id: json['id'] as int?,
    nome: json['nome'] as String,
    telefone: json['telefone'] as String,
    email: json['email'] as String,
    senha: json['senha'] as String,
    cpf: json['cpf'] as String,
  );
  
  Map<String, dynamic> toJson() =>{
    'id': id,
    'nome': nome,
    'telefone': telefone,
    'email': email,
    'senha': senha,
    'cpf': cpf
  };

  Usuario copyWith({
    int? id,
    String? nome,
    String? telefone,
    String? email,
    String? senha,
    String? cpf
  }) => 
  Usuario(
    id: id ?? this.id,
    nome: nome ?? this.nome,
    telefone: telefone ?? this.telefone,
    email: email ?? this.email,
    senha: senha ?? this.senha,
    cpf: cpf ?? this.cpf
  );
}