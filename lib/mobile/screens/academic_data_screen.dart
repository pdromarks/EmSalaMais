import 'package:em_sala_mais/backend/services/mobile_user.service.dart';
import 'package:em_sala_mais/backend/services/group.service.dart';
import 'package:em_sala_mais/backend/model/group.dart';
import 'package:em_sala_mais/backend/model/course.dart';
import 'package:em_sala_mais/backend/model/enums.dart';
import 'package:em_sala_mais/mobile/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../components/widgets/custom_tf.dart';
import '../../components/widgets/custom_btn.dart';
import '../../components/widgets/custom_dropdown.dart';
import '../../theme/theme.dart';

class AcademicDataScreen extends StatefulWidget {
  const AcademicDataScreen({super.key});

  @override
  State<AcademicDataScreen> createState() => _AcademicDataScreenState();
}

class _AcademicDataScreenState extends State<AcademicDataScreen> {
  final _groupService = GroupService();
  final _mobileUserService = MobileUserService();
  final _supabase = Supabase.instance.client;

  final _nameController = TextEditingController();
  bool _isLoading = true;
  String? _error;

  // Lista completa de turmas do banco
  List<Group> _allGroups = [];
  
  // Listas para os dropdowns
  List<DropdownValueModel> _cursos = [];
  List<DropdownValueModel> _semestres = [];
  List<DropdownValueModel> _periodos = [];
  List<DropdownValueModel> _turmas = [];

  // Valores selecionados
  DropdownValueModel? selectedCurso;
  DropdownValueModel? selectedSemestre;
  DropdownValueModel? selectedPeriodo;
  DropdownValueModel? selectedTurma;
  String? openDropdown;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      // Busca todas as turmas do banco
      final groups = await _groupService.getGroups();
      setState(() {
        _allGroups = groups;
        
        // Popula apenas o dropdown de cursos inicialmente
        final cursosMap = groups.map((g) => g.course).toSet().toList();
        _cursos = cursosMap.map((c) => 
          DropdownValueModel(
            value: c.id.toString(),
            label: c.name,
          )
        ).toList();
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Atualiza os semestres disponíveis quando um curso é selecionado
  void _updateSemestres(DropdownValueModel? curso) {
    setState(() {
      selectedCurso = curso;
      // Reseta as seleções seguintes
      selectedSemestre = null;
      selectedPeriodo = null;
      selectedTurma = null;
      _semestres = [];
      _periodos = [];
      _turmas = [];

      if (curso == null) return;

      // Filtra os semestres disponíveis para o curso selecionado
      final semestresDisponiveis = _allGroups
          .where((g) => g.course.id.toString() == curso.value)
          .map((g) => g.semester)
          .toSet()
          .toList();

      _semestres = semestresDisponiveis.map((s) {
        final idx = Semester.values.indexOf(s) + 1;
        return DropdownValueModel(
          value: s.name,
          label: '${idx}º Semestre',
        );
      }).toList();
    });
  }

  // Atualiza os períodos disponíveis quando um semestre é selecionado
  void _updatePeriodos(DropdownValueModel? semestre) {
    setState(() {
      selectedSemestre = semestre;
      // Reseta as seleções seguintes
      selectedPeriodo = null;
      selectedTurma = null;
      _periodos = [];
      _turmas = [];

      if (semestre == null || selectedCurso == null) return;

      // Filtra os períodos disponíveis para o curso e semestre selecionados
      final periodosDisponiveis = _allGroups
          .where((g) => 
            g.course.id.toString() == selectedCurso!.value &&
            g.semester.name == semestre.value)
          .map((g) => _getPeriodFromSemester(g.semester))
          .toSet()
          .toList();

      _periodos = periodosDisponiveis.map((p) => 
        DropdownValueModel(
          value: p.toLowerCase(),
          label: p,
        )
      ).toList();
    });
  }

  // Atualiza as turmas disponíveis quando um período é selecionado
  void _updateTurmas(DropdownValueModel? periodo) {
    setState(() {
      selectedPeriodo = periodo;
      // Reseta a seleção seguinte
      selectedTurma = null;
      _turmas = [];

      if (periodo == null || selectedCurso == null || selectedSemestre == null) return;

      // Filtra as turmas disponíveis para o curso, semestre e período selecionados
      final turmasDisponiveis = _allGroups.where((g) =>
        g.course.id.toString() == selectedCurso!.value &&
        g.semester.name == selectedSemestre!.value &&
        _getPeriodFromSemester(g.semester).toLowerCase() == periodo.value
      ).toList();

      _turmas = turmasDisponiveis.map((g) => 
        DropdownValueModel(
          value: g.id.toString(), // Agora usamos o ID da turma como valor
          label: g.name,
        )
      ).toList();
    });
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

  Future<void> _saveAcademicData() async {
    if (_nameController.text.isEmpty || selectedTurma == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Não precisamos mais procurar a turma, já temos o ID direto
      final groupId = int.parse(selectedTurma!.value);

      await _mobileUserService.linkUserToGroup(
        userId: _supabase.auth.currentUser!.id,
        groupId: groupId,
        name: _nameController.text.trim(),
      );

      if (mounted) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar dados: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleDropdownOpen(String dropdownId) {
    setState(() {
      openDropdown = openDropdown != dropdownId ? dropdownId : null;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;
    final double height = screenSize.height;
    final bool isDesktop = width > 1024;

    double horizontalPadding;
    double logoHeight;
    double verticalSpacing;
    double cardWidth;
    double cardPadding;
    double fontSize;
    double buttonFontSize;
    double iconSize;

    if (isDesktop) {
      horizontalPadding = 0;
      logoHeight = width * 0.08;
      verticalSpacing = height * 0.03;
      cardWidth = width * 0.25;
      cardWidth = cardWidth.clamp(340.0, 420.0);
      cardPadding = 30.0;
      fontSize = 16.0;
      buttonFontSize = 16.0;
      iconSize = 22.0;
    } else {
      horizontalPadding = width * 0.08;
      logoHeight = height * 0.15;
      verticalSpacing = height * 0.02;
      cardWidth = width - (horizontalPadding * 2);
      cardPadding = width * 0.06;
      fontSize = (width * 0.04).clamp(14.0, 20.0);
      buttonFontSize = (width * 0.04).clamp(14.0, 20.0);
      iconSize = (width * 0.05).clamp(18.0, 24.0);
    }

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xfff1f1f1),
        body: Center(
          child: CircularProgressIndicator(color: AppColors.verdeUNICV),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: const Color(0xfff1f1f1),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Erro ao carregar dados: $_error'),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Tentar Novamente',
                onPressed: _fetchInitialData,
                backgroundColor: AppColors.verdeUNICV,
              ),
            ],
          ),
        ),
      );
    }

    Widget buildForm() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: logoHeight,
            child: Image.asset('assets/images/LogoUNICV.png'),
          ),
          SizedBox(height: verticalSpacing * 1.2),
          Text(
            'Seus Dados Acadêmicos',
            style: TextStyle(
              color: AppColors.verdeUNICV,
              fontSize: fontSize * 1.5,
              fontWeight: FontWeight.w800,
              fontFamily: 'Inter',
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: verticalSpacing),
          CustomTextField(
            controller: _nameController,
            label: 'Seu Nome Completo',
            borderColor: AppColors.verdeUNICV,
            labelColor: AppColors.verdeUNICV,
            fontSize: fontSize,
          ),
          SizedBox(height: verticalSpacing),
          CustomDropdown(
            label: 'Seu Curso',
            fontSize: fontSize,
            items: _cursos,
            selectedValue: selectedCurso,
            onChanged: _updateSemestres,
            onOpen: () => _handleDropdownOpen('curso'),
            dropdownId: 'curso',
            openDropdownId: openDropdown,
            enableSearch: true,
          ),
          SizedBox(height: verticalSpacing),
          Row(
            children: [
              Expanded(
                child: CustomDropdown(
                  label: 'Semestre',
                  fontSize: fontSize,
                  items: _semestres,
                  selectedValue: selectedSemestre,
                  onChanged: _updatePeriodos,
                  onOpen: () => _handleDropdownOpen('semestre'),
                  dropdownId: 'semestre',
                  openDropdownId: openDropdown,
                  isEnabled: selectedCurso != null,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: CustomDropdown(
                  label: 'Período',
                  fontSize: fontSize,
                  items: _periodos,
                  selectedValue: selectedPeriodo,
                  onChanged: _updateTurmas,
                  onOpen: () => _handleDropdownOpen('periodo'),
                  dropdownId: 'periodo',
                  openDropdownId: openDropdown,
                  isEnabled: selectedSemestre != null,
                ),
              ),
            ],
          ),
          SizedBox(height: verticalSpacing),
          CustomDropdown(
            label: 'Turma',
            fontSize: fontSize,
            items: _turmas,
            selectedValue: selectedTurma,
            onChanged: (value) => setState(() => selectedTurma = value),
            onOpen: () => _handleDropdownOpen('turma'),
            dropdownId: 'turma',
            openDropdownId: openDropdown,
            isEnabled: selectedPeriodo != null,
          ),
          SizedBox(height: verticalSpacing * 2),
          CustomButton(
            text: 'Próximo',
            onPressed: _saveAcademicData,
            backgroundColor: AppColors.verdeUNICV,
            icon: Icons.arrow_forward_rounded,
            width: double.infinity,
            height: 48,
            fontSize: buttonFontSize,
            iconSize: iconSize,
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xfff1f1f1),
      body: Center(
        child: SingleChildScrollView(
          child: isDesktop
              ? Container(
                  width: cardWidth,
                  padding: EdgeInsets.all(cardPadding),
                  child: buildForm(),
                )
              : Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalSpacing * 2,
                  ),
                  child: buildForm(),
                ),
        ),
      ),
    );
  }
}
