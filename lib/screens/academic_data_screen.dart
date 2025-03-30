import 'package:flutter/material.dart';
import '../widgets/custom_tf.dart';
import '../widgets/custom_btn.dart';
import '../widgets/custom_dropdown.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff1f1f1),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 45),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 60),
                Container(
                  height: 140,
                  child: Image.asset('assets/images/LogoUNICV.png'),
                ),
                const SizedBox(height: 30),
                Text(
                  'Seus Dados',
                  style: TextStyle(
                    color: AppColors.verdeUNICV,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 20),
                const CustomTextField(
                  label: 'Seu Nome',
                  borderColor: AppColors.verdeUNICV,
                  labelColor: AppColors.verdeUNICV,
                ),
                const SizedBox(height: 10),
                CustomDropdown(
                  label: 'Seu Curso',
                  items: cursos,
                  selectedValue: selectedCurso,
                  onChanged: (value) {
                    setState(() {
                      selectedCurso = value;
                      openDropdown = null;
                    });
                  },
                  onOpen: () => _handleDropdownOpen('curso'),
                  dropdownId: 'curso',
                  openDropdownId: openDropdown,
                  enableSearch: true,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomDropdown(
                      width: MediaQuery.of(context).size.width / 2.7,
                      label: 'Semestre',
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
                      width: MediaQuery.of(context).size.width / 2.7,
                      label: 'Turno',
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
                const SizedBox(height: 100),
                CustomButton(
                  text: 'Próximo',
                  onPressed: () {},
                  backgroundColor: AppColors.verdeUNICV,
                  icon: Icons.arrow_forward_rounded,
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
