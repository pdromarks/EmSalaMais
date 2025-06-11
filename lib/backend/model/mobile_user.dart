import 'package:em_sala_mais/backend/model/group.dart';

class MobileUser {
  final String id;
  final String idUser;
  final Group group;

  MobileUser({required this.id, required this.idUser, required this.group});
}
