class Usuario {
  final int? id;
  final String? firebaseUID;
  final String nome;
  final String telefone;
  final String email;
  final String senha;
  final String cpf;
  final int? isAdmin;

  const Usuario({
    this.id,
    this.firebaseUID,
    required this.nome,
    required this.telefone,
    required this.email,
    required this.senha,
    required this.cpf,
    this.isAdmin
  });

  static Usuario fromJson(Map<String, dynamic> json) => Usuario(
    id: json['id'] as int?,
    firebaseUID: json['firebaseUID'] as String,
    nome: json['nome'] as String,
    telefone: json['telefone'] as String,
    email: json['email'] as String,
    senha: json['senha'] as String,
    cpf: json['cpf'] as String,
    isAdmin: json['isAdmin'] as int?
  );
  
  Map<String, dynamic> toJson() =>{
    'id': id,
    'firebaseUID': firebaseUID,
    'nome': nome,
    'telefone': telefone,
    'email': email,
    'senha': senha,
    'cpf': cpf,
    'isAdmin': isAdmin
  };

  Usuario copyWith({
    int? id,
    String? firebaseUID,
    String? nome,  
    String? telefone,
    String? email,
    String? senha,
    String? cpf,
    int? isAdmin
  }) => 
  Usuario(
    id: id ?? this.id,
    firebaseUID: firebaseUID ?? this.firebaseUID,
    nome: nome ?? this.nome,
    telefone: telefone ?? this.telefone,
    email: email ?? this.email,
    senha: senha ?? this.senha,
    cpf: cpf ?? this.cpf,
    isAdmin: isAdmin ?? this.isAdmin
  );
}