import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final supabase = Supabase.instance.client;

  Future<AuthResponse?> signUpUser(String password, String email) async {
    
    try{
      AuthResponse userData = await supabase.auth.signUp(password: password, email: email);

      if(userData.user == null){
        throw AuthException("Erro ao realizar o cadastro do pança larga");
      }

      return userData;

    }catch(e){
      return null;
    }
  }

  Future<AuthResponse> signIn(String password, String email) async {
    AuthResponse userData = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if(userData.user == null){
      throw AuthException("Erro ao realizar o login do pança larga");
    }

    return userData;
  }
}