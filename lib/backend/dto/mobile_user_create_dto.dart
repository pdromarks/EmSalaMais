class MobileUserCreateDTO {
  final int idGroup;
  final String email;
  final String password;
  final String? name;

  MobileUserCreateDTO(
      {required this.idGroup, required this.email, required this.password, this.name});
}
