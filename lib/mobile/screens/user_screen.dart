import 'package:flutter/material.dart';
import '../../theme/theme.dart'; // Garanta que AppColors.verdeUNICV esteja definido aqui

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
  // Dados mocados para o perfil do usuário
  late UserProfile _userProfile; // Alterado para late para permitir modificação

  @override
  void initState() { // Adicionado initState para inicializar _userProfile
    super.initState();
    _userProfile = UserProfile(
      nomeCompleto: 'Pedro Marques Fonseca',
      cursos: [
        UserCurso(nomeCurso: 'Engenharia de Software', semestre: '7º', turno: 'Noturno', turma: 'A'),
        UserCurso(nomeCurso: 'Ciência da Computação', semestre: '3º', turno: 'Matutino', turma: 'B'),
        UserCurso(nomeCurso: 'Análise e Desenvolvimento de Sistemas', semestre: '1º', turno: 'Noturno'),
      ],
    );
  }

  void _adicionarNovoCurso() {
    // TODO: Implementar a navegação para uma tela de adição de curso ou um modal
    print('Botão Adicionar Novo Curso Pressionado');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Funcionalidade de adicionar novo curso ainda não implementada.')),
    );
    // Exemplo de como adicionar (apenas para teste, UI de adição necessária):
    // setState(() {
    //   _userProfile.cursos.add(UserCurso(nomeCurso: "Novo Curso Adicionado", semestre: "1º", turno: "Noite"));
    // });
  }

  void _editarCurso(UserCurso cursoParaEditar) {
    // TODO: Implementar a navegação para uma tela de edição de curso ou um modal
    print('Botão Editar Curso Pressionado para: ${cursoParaEditar.nomeCurso}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Funcionalidade de editar o curso "${cursoParaEditar.nomeCurso}" ainda não implementada.')),
    );
  }

  void _removerCurso(UserCurso cursoParaRemover) {
    setState(() {
      _userProfile.cursos.removeWhere((curso) => curso == cursoParaRemover);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Curso "${cursoParaRemover.nomeCurso}" removido.')),
    );
  }

  void _sair() {
    // Implementar a lógica de logout
    // Por exemplo, navegar para a tela de login e limpar dados de sessão
    print('Botão Sair pressionado');
    // Navigator.of(context).pushAndRemoveUntil(
    //   MaterialPageRoute(builder: (context) => LoginScreen()), // Substitua LoginScreen pela sua tela de login
    //   (Route<dynamic> route) => false,
    // );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Funcionalidade de Sair ainda não implementada.')),
    );
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
            offset: const Offset(0, 3), // changes position of shadow
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

  Widget _buildCursoCard(UserCurso curso) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 16.0, right: 8.0),
      margin: const EdgeInsets.only(bottom: 12.0),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  curso.nomeCurso,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.verdeUNICV, // Usando a cor do tema
                  ),
                ),
                const SizedBox(height: 8.0),
                Text('Semestre: ${curso.semestre}', style: const TextStyle(fontSize: 15, color: Colors.black54)),
                Text('Turno: ${curso.turno}', style: const TextStyle(fontSize: 15, color: Colors.black54)),
                if (curso.turma != null && curso.turma!.isNotEmpty)
                  Text('Turma: ${curso.turma}', style: const TextStyle(fontSize: 15, color: Colors.black54)),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit_outlined, color: AppColors.verdeUNICV.withOpacity(0.8), size: 22),
                tooltip: 'Editar Curso',
                onPressed: () => _editarCurso(curso),
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 4),
              IconButton(
                icon: Icon(Icons.remove_circle_outline, color: Colors.red[400], size: 22),
                tooltip: 'Remover Curso',
                onPressed: () => _removerCurso(curso),
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
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
        elevation: 1.0, // Sombra sutil
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.verdeUNICV),
          onPressed: () => Navigator.of(context).pop(),
        ),
        iconTheme: const IconThemeData(color: AppColors.verdeUNICV),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildInfoContainer('Nome Completo', _userProfile.nomeCompleto),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Meus Cursos',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.verdeUNICV,
                    fontFamily: 'Inter',
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, color: AppColors.verdeUNICV, size: 24),
                  tooltip: 'Adicionar Novo Curso',
                  onPressed: _adicionarNovoCurso,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            if (_userProfile.cursos.isEmpty)
              const Center(child: Text('Nenhum curso cadastrado.'))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _userProfile.cursos.length,
                itemBuilder: (context, index) {
                  return _buildCursoCard(_userProfile.cursos[index]);
                },
              ),
            const SizedBox(height: 30.0),
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