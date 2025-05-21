import 'package:flutter/material.dart';
import '../components/widgets/custom_tf.dart';
import '../components/widgets/custom_btn.dart';
import '../components/widgets/custom_dropdown.dart';
import '../theme/theme.dart';

class AcademicDataScreen extends StatefulWidget {
  const AcademicDataScreen({super.key});

  @override
  State<AcademicDataScreen> createState() => _AcademicDataScreenState();
}

class _AcademicDataScreenState extends State<AcademicDataScreen> {
  DropdownValueModel? selectedCurso;
  DropdownValueModel? selectedSemestre;
  DropdownValueModel? selectedTurno;
  DropdownValueModel? selectedTurma;
  String? openDropdown;

  void _handleDropdownOpen(String dropdownId) {
    if (openDropdown != null && openDropdown != dropdownId) {
      // Fecha o dropdown anterior
      setState(() {
        openDropdown = dropdownId;
      });
    } else {
      setState(() {
        openDropdown = dropdownId;
      });
    }
  }

  final List<DropdownValueModel> cursos = [
    DropdownValueModel(value: '1', label: 'Engenharia de Software'),
    DropdownValueModel(value: '2', label: 'Ciência da Computação'),
    DropdownValueModel(value: '3', label: 'Sistemas de Informação'),
  ];

  final List<DropdownValueModel> semestres = [
    DropdownValueModel(value: '1', label: '1º'),
    DropdownValueModel(value: '2', label: '2º'),
    DropdownValueModel(value: '3', label: '3º'),
    DropdownValueModel(value: '4', label: '4º'),
  ];

  final List<DropdownValueModel> turnos = [
    DropdownValueModel(value: '1', label: 'Manhã'),
    DropdownValueModel(value: '2', label: 'Tarde'),
    DropdownValueModel(value: '3', label: 'Noite'),
  ];

  // Mapa de turmas por curso
  final Map<String, List<DropdownValueModel>> turmasPorCurso = {
    '1': [ // Engenharia de Software
      DropdownValueModel(value: '1', label: 'A'),
      DropdownValueModel(value: '2', label: 'B'),
      DropdownValueModel(value: '3', label: 'C'),
    ],
    '2': [ // Ciência da Computação
      DropdownValueModel(value: '1', label: 'Turma Única'),
    ],
    '3': [ // Sistemas de Informação
      DropdownValueModel(value: '1', label: 'Turma X'),
      DropdownValueModel(value: '2', label: 'Turma Y'),
    ],
  };

  // Método para obter as turmas disponíveis do curso selecionado
  List<DropdownValueModel> getTurmas() {
    if (selectedCurso == null) {
      return [];
    }
    return turmasPorCurso[selectedCurso!.value] ?? [];
  }

  // Verifica se o curso selecionado tem mais de uma turma
  bool cursoTemMultiplasTurmas() {
    if (selectedCurso == null) {
      return false;
    }
    final turmas = turmasPorCurso[selectedCurso!.value];
    return turmas != null && turmas.length > 1;
  }

  @override
  Widget build(BuildContext context) {
    // Obtém as turmas disponíveis para o curso selecionado
    final turmas = getTurmas();
    
    // Verifica se deve exibir o dropdown de turma
    final exibirDropdownTurma = cursoTemMultiplasTurmas();

    //Responsividade
    final Size screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;
    final double height = screenSize.height;
    
    final double horizontalPadding = width * 0.08;
    final double logoHeight = height * 0.15;
    final double fieldWidth = width - (horizontalPadding * 2);
    final double halfFieldWidth = (fieldWidth / 2) - 5;
    final double verticalSpacing = height * 0.015;
    final double bottomSpacing = height * 0.1;

    final double inputFontSize = (width * 0.04).clamp(14.0, 20.0);
    final double titleFontSize = (width * 0.08).clamp(20.0, 40.0);
    final double btnFontSize = (width * 0.06).clamp(8.0, 20.0);
    final double iconSize = (width * 0.05).clamp(10.0, 20.0);
  



    return Scaffold(
      backgroundColor: const Color(0xfff1f1f1),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: height * 0.06),
                    SizedBox(
                      height: logoHeight,
                      child: Image.asset('assets/images/LogoUNICV.png'),
                    ),
                    SizedBox(height: height * 0.03),
                    Text(
                      'Seus Dados',
                      style: TextStyle(
                        color: AppColors.verdeUNICV,
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                     CustomTextField(
                      label: 'Seu Nome',
                      borderColor: AppColors.verdeUNICV,
                      labelColor: AppColors.verdeUNICV,
                      fontSize: inputFontSize,
                    ),
                    SizedBox(height: verticalSpacing),
                    CustomDropdown(
                      label: 'Seu Curso',
                      fontSize: inputFontSize,
                      items: cursos,
                      selectedValue: selectedCurso,
                      onChanged: (value) {
                        setState(() {
                          selectedCurso = value;
                          // Reseta a turma selecionada ao trocar de curso
                          selectedTurma = null;
                          openDropdown = null;
                        });
                      },
                      onOpen: () => _handleDropdownOpen('curso'),
                      dropdownId: 'curso',
                      openDropdownId: openDropdown,
                      enableSearch: true,
                    ),
                    SizedBox(height: verticalSpacing),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomDropdown(
                          width: halfFieldWidth,
                          label: 'Semestre',
                          fontSize: inputFontSize,
                          items: semestres,
                          selectedValue: selectedSemestre,
                          onChanged: (value) {
                            setState(() {
                              selectedSemestre = value;
                              openDropdown = null;
                            });
                          },
                          onOpen: () => _handleDropdownOpen('semestre'),
                          dropdownId: 'semestre',
                          openDropdownId: openDropdown,
                        ),
                        CustomDropdown(
                          width: halfFieldWidth,
                          label: 'Turno',
                          fontSize: inputFontSize,
                          items: turnos,
                          selectedValue: selectedTurno,
                          onChanged: (value) {
                            setState(() {
                              selectedTurno = value;
                              openDropdown = null;
                            });
                          },
                          onOpen: () => _handleDropdownOpen('turno'),
                          dropdownId: 'turno',
                          openDropdownId: openDropdown,
                        ),
                      ],
                    ),
                    SizedBox(height: verticalSpacing),
                    SizedBox(
                      height: 50,
                      child: Center(
                        child: Visibility(
                          visible: exibirDropdownTurma,
                          maintainSize: false,
                          maintainAnimation: true,
                          maintainState: true,
                          child: CustomDropdown(
                            width: halfFieldWidth,
                            label: 'Turma',
                            fontSize: inputFontSize,
                            items: turmas,
                            selectedValue: selectedTurma,
                            onChanged: (value) {
                              setState(() {
                                selectedTurma = value;
                                openDropdown = null;
                              });
                            },
                            onOpen: () => _handleDropdownOpen('turma'),
                            dropdownId: 'turma',
                            openDropdownId: openDropdown,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: bottomSpacing),
                    CustomButton(
                      text: 'Próximo',
                      onPressed: () {},
                      backgroundColor: AppColors.verdeUNICV,
                      icon: Icons.arrow_forward_rounded,
                      width: width * 0.45,
                      height: height * 0.055,
                      fontSize: btnFontSize,
                      iconSize: iconSize,
                    ),
                    SizedBox(height: height * 0.03),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
