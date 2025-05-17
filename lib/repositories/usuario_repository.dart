
import 'package:casadosushi/database/dao/usuarioDAO.dart';
import 'package:casadosushi/models/usuario.dart';

class UsuarioRepository {
  UsuarioDAO usuarioDAO = UsuarioDAO();

  Future<Usuario> insertUser(Usuario usuario) => usuarioDAO.insertUser(usuario);

  Future<List<Usuario>> listUser() => usuarioDAO.listUser();

  Future<void> updateUser(Usuario usuario, int id) => usuarioDAO.updateUser(usuario, id);

  Future<void> deleteUser(int id) => usuarioDAO.deleteUser(id);

  Future<bool> authUser(String email, String senha) => usuarioDAO.authUser(email, senha);

  Future<String> checkUser(String email, String telefone, String cpf) => usuarioDAO.checkUser(email, telefone, cpf);
  
  Future<bool> checkIfAdmin(String uid) => usuarioDAO.checkIfAdmin(uid);
}