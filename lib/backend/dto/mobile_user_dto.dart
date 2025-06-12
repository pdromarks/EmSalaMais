class MobileUserDTO {
  final int id;
  final String? idUser;
  final int idGroup;
  final String? name;

  MobileUserDTO({required this.id, required this.idGroup, this.idUser, this.name});

  factory MobileUserDTO.fromJson(Map<String, dynamic> json) {
    return MobileUserDTO(
      id: json['id'],
      idUser: json['id_usuario'],
      idGroup: json['id_turma'],
      name: json['nome'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'id_user': idUser, 'id_group': idGroup, 'name': name};
  }
}
