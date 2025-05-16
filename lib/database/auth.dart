import 'package:casadosushi/models/usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

abstract class AbsAuth{
  Future<String> usuarioAtual();
  Future<String> cadastro(String email, String senha);
  Future<String> login(String email, String senha);
  Future<void> logout();
}

class Auth implements AbsAuth{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<String> login(String email, String senha) async{
    UserCredential userCred = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: senha);
    return userCred.user!.uid;
  }

  @override
  Future<String> cadastro(String email, String senha) async{
    UserCredential userCred = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: senha);
    return userCred.user!.uid;
  }

  @override
  Future<String> usuarioAtual() async {
    User user = _firebaseAuth.currentUser!;
    return user.uid;
  }

  @override
  Future<void> logout() async{
    return _firebaseAuth.signOut();
  }
}