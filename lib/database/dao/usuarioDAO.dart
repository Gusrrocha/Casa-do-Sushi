import 'package:casadosushi/database/database_helper.dart';
import 'package:casadosushi/models/usuario.dart';
import 'package:sqflite/sqflite.dart';

class UsuarioDAO {
  Future<Database> get _db async => await DatabaseHelper().database;

  Future<Usuario> insertUser(Usuario usuario) async {
    final db = await _db;
    final id = await db.insert('Usuario', usuario.toJson());
    return usuario.copyWith(id: id);
  }

  Future<List<Usuario>> listUser() async {
    final db = await _db;
    final lista = await db.query('Usuario');
    return lista.map((json) => Usuario.fromJson(json)).toList();
  }

  Future<void> updateUser(Usuario usuario, int id) async {
    final db = await _db;
    await db.update('Usuario', usuario.toJson(), where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteUser(int id) async {
    final db = await _db;
    await db.delete('Usuario', where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> authUser(String email, String senha) async{
    final db = await _db;
    final result = await db.rawQuery("SELECT * FROM Usuario WHERE email = '$email' AND senha = $senha");
    return result.isNotEmpty ? true : false;
  }

  Future<String> checkUser(Usuario usuario) async{
    final db = await _db;
    var result = await db.rawQuery("SELECT * FROM Usuario WHERE email = '${usuario.email}'");
    if(result.isNotEmpty) return "Já existe um usuário com este e-mail";
    result = await db.rawQuery("SELECT * FROM Usuario WHERE telefone = '${usuario.telefone}'");
    if(result.isNotEmpty) return "Já existe um usuário com este número de telefone";
    result = await db.rawQuery("SELECT * FROM Usuario WHERE cpf = '${usuario.cpf}'");
    if(result.isNotEmpty) return "Já existe um usuário com este CPF";

    return "";
  }

}