import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final SupabaseClient supabaseClient;

  UserService({required this.supabaseClient});

  static Future<UserService> create() async {
    return UserService(supabaseClient: Supabase.instance.client);
  }

  // You can now use supabaseClient wherever necessary
  // For example, here's how you could use it to fetch data
  Future<void> fetchData() async {
    final response = await supabaseClient.from('users').select('id');
    if( response.toList().length != 0){
      print(response.toList()[0]);
      return;
    }
    print("ta vazio");
  }
}