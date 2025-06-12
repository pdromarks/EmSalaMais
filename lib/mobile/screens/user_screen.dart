import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../theme/theme.dart';
import '../../backend/services/mobile_user.service.dart';
import '../../backend/services/group.service.dart';
import '../../backend/model/group.dart';
import '../../backend/model/enums.dart';
import '../screens/login_screen.dart';

// Modelos de dados (geralmente em arquivos separados)
class UserProfile {
  String nomeCompleto;
  List<UserCurso> cursos;

  UserProfile({required this.nomeCompleto, required this.cursos});
}

class UserCurso {
  String nomeCurso;
  String semestre;
  String turno;
  String? turma; // Opcional

  UserCurso({
    required this.nomeCurso,
    required this.semestre,
    required this.turno,
    this.turma,
  });
}

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final _mobileUserService = MobileUserService();
  final _groupService = GroupService();
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  String? _userName;
  Group? _userGroup;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  String _formatSemester(Semester semester) {
    final idx = Semester.values.indexOf(semester) + 1;
    return '${idx}º Semestre';
  }

  String _getPeriodFromSemester(Semester s) {
    switch (s) {
      case Semester.primeiro:
      case Semester.segundo:
        return 'Matutino';
      case Semester.terceiro:
      case Semester.quarto:
        return 'Vespertino';
      case Semester.quinto:
      case Semester.sexto:
      case Semester.setimo:
      case Semester.oitavo:
      case Semester.nono:
      case Semester.decimo:
        return 'Noturno';
      default:
        return 'Noturno';
    }
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final userData = await _mobileUserService.getMobileUserByAuthId(
        _supabase.auth.currentUser!.id,
      );
      
      if (userData != null) {
        final group = await _groupService.getGroup(userData.idGroup);
        setState(() {
          _userName = userData.name;
          _userGroup = group;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Erro ao carregar dados do usuário';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _sair() async {
    try {
      await _supabase.auth.signOut();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao sair do sistema')),
        );
      }
    }
  }

  Widget _buildInfoContainer(String title, String content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            content,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassInfoCard() {
    if (_userGroup == null) {
      return const Center(child: Text('Nenhuma informação acadêmica disponível.'));
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _userGroup!.course.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.verdeUNICV,
            ),
          ),
          const SizedBox(height: 16.0),
          _buildInfoRow(
            icon: Icons.school,
            label: 'Semestre',
            value: _formatSemester(_userGroup!.semester),
          ),
          const SizedBox(height: 12.0),
          _buildInfoRow(
            icon: Icons.access_time,
            label: 'Período',
            value: _getPeriodFromSemester(_userGroup!.semester),
          ),
          const SizedBox(height: 12.0),
          _buildInfoRow(
            icon: Icons.groups,
            label: 'Turma',
            value: _userGroup!.name,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8.0),
        Text(
          '$label:',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8.0),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double horizontalPadding = screenWidth * 0.05;

    return Scaffold(
      backgroundColor: const Color(0xfff1f1f1),
      appBar: AppBar(
        title: const Text(
          'Meu Perfil',
          style: TextStyle(color: AppColors.verdeUNICV, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.verdeUNICV),
          onPressed: () => Navigator.of(context).pop(),
        ),
        iconTheme: const IconThemeData(color: AppColors.verdeUNICV),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.verdeUNICV))
          : _error != null
              ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
              : SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildInfoContainer('Nome Completo', _userName ?? 'Nome não disponível'),
                      const SizedBox(height: 10.0),
                      const Text(
                        'Informações Acadêmicas',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.verdeUNICV,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      _buildClassInfoCard(),
                    ],
                  ),
                ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(horizontalPadding).copyWith(bottom: 20.0),
        child: ElevatedButton.icon(
          icon: const Icon(Icons.exit_to_app, color: Colors.white),
          label: const Text('Sair', style: TextStyle(fontSize: 16, color: Colors.white)),
          onPressed: _sair,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.verdeUNICV,
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            minimumSize: const Size(double.infinity, 50), 
          ),
        ),
      ),
    );
  }
}