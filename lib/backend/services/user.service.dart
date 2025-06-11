import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final supabase = Supabase.instance.client;

  Future<AuthResponse?> signUpUser(String password, String email) async {
    try {
      AuthResponse userData = await supabase.auth.signUp(
        password: password,
        email: email,
      );
      if (userData.user == null) {
        throw AuthException("Erro ao realizar o cadastro");
      }

      return userData;
    } catch (e) {
      print(e);
      throw AuthException("Erro ao realizar o cadastro");
    }
  }

  Future<Session?> signIn(String password, String email) async {
    try {
      AuthResponse userData = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (userData.user == null) {
        throw AuthException("Erro ao realizar o login");
      }

      return userData.session;
    } catch (e) {
      print(e);
      throw AuthException("Credenciais inválidas");
    }
  }
}
