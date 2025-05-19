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
    final result = await db.rawQuery("SELECT * FROM Usuario WHERE email = '$email' AND senha = '$senha'");
    return result.isNotEmpty ? true : false;
  }

  Future<String> checkUser(String email, String telefone, String cpf) async{
    final db = await _db;
    var result = await db.rawQuery("SELECT * FROM Usuario WHERE email = '$email'");
    if(result.isNotEmpty) return "Já existe um usuário com este e-mail";
    result = await db.rawQuery("SELECT * FROM Usuario WHERE telefone = '$telefone'");
    if(result.isNotEmpty) return "Já existe um usuário com este número de telefone";
    result = await db.rawQuery("SELECT * FROM Usuario WHERE cpf = '$cpf'");
    if(result.isNotEmpty) return "Já existe um usuário com este CPF";

    return "";
  }

  Future<bool> checkIfAdmin(String uid) async {
    final db = await _db;
    final result = await db.rawQuery("SELECT isAdmin FROM Usuario WHERE firebaseUID = '$uid'");
    return result.first['isAdmin'] != 0 ? true : false;
  }

  Future<int> getUserByUID(String uid) async {
    final db = await _db;
    final result = await db.query('Usuario', columns: ['id'], where: 'firebaseUID = ?', whereArgs: [uid]);
    return result.first['id'] as int;
  }

  
}