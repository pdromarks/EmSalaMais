import 'package:flutter/material.dart';
import '../../theme/theme.dart'; // Assuming theme.dart is in lib/theme/

class SearchTeacherScreen extends StatefulWidget {
  const SearchTeacherScreen({super.key});

  @override
  State<SearchTeacherScreen> createState() => _SearchTeacherScreenState();
}

class _SearchTeacherScreenState extends State<SearchTeacherScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedPeriodo;
  String? _selectedHorario;

  // Mock data for periods and horarios
  final List<String> _periodos = ['Matutino', 'Vespertino', 'Noturno'];
  final List<String> _horarios = ['1º horário', '2º horário',];

  // Mock data for teachers - replace with actual data source
  final List<Map<String, String>> _allTeachers = [
    {'professor': 'Prof. Dr. João Silva', 'sala': 'Sala 101'},
    {'professor': 'Profa. Dra. Maria Oliveira', 'sala': 'Lab. Info II'},
    {'professor': 'Prof. Carlos Alberto', 'sala': 'Sala 203'},
    {'professor': 'Profa. Ana Beatriz', 'sala': 'Sala 105'},
    {'professor': 'Prof. Ricardo Gomes', 'sala': 'Auditório'},
  ];

  List<Map<String, String>> _filteredTeachers = [];

  @override
  void initState() {
    super.initState();
    _filteredTeachers = _allTeachers;
    _searchController.addListener(_filterTeachers);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterTeachers);
    _searchController.dispose();
    super.dispose();
  }

  void _filterTeachers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTeachers = _allTeachers.where((teacher) {
        final teacherName = teacher['professor']!.toLowerCase();
        final matchesQuery = teacherName.contains(query);
        // TODO: Add filtering by _selectedPeriodo and _selectedHorario if needed
        return matchesQuery;
      }).toList();
    });
  }

  Widget _buildTeacherListItem(Map<String, String> teacherData) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0.5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        title: Text(
          teacherData['professor']!,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        trailing: Text(
          teacherData['sala']!,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        // onTap: () {
        //   // TODO: Handle teacher tap, e.g., navigate to teacher details
        //   print('Tapped on ${teacherData['professor']}');
        // },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;
    // final double height = screenSize.height; // Uncomment if needed
    
    final double horizontalPadding = width * 0.05;
    // final double verticalSpacing = height * 0.02; // Uncomment if needed

    return Scaffold(
      backgroundColor: const Color(0xfff1f1f1),
      // appBar: AppBar( // Optional: Add AppBar if needed, otherwise it inherits from HomeScreen
      //   title: const Text('Buscar Professores', style: TextStyle(color: AppColors.verdeUNICV)),
      //   backgroundColor: Colors.white,
      //   iconTheme: IconThemeData(color: AppColors.verdeUNICV),
      //   elevation: 1.0,
      // ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Buscar Professores',
              style: TextStyle(
                fontSize: 24, // Consistent with RoomAllocationScreen title style
                fontWeight: FontWeight.bold,
                color: AppColors.verdeUNICV, // Using theme color
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Digite o nome do professor...',
                prefixIcon: const Icon(Icons.search, color: AppColors.verdeUNICV),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: <Widget>[
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Período',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    ),
                    value: _selectedPeriodo,
                    hint: const Text('Selecione'),
                    icon: const Icon(Icons.arrow_drop_down, color: AppColors.verdeUNICV),
                    items: _periodos.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedPeriodo = newValue;
                        _filterTeachers(); // Re-filter when period changes
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Horário',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    ),
                    value: _selectedHorario,
                    hint: const Text('Selecione'),
                    icon: const Icon(Icons.arrow_drop_down, color: AppColors.verdeUNICV),
                    items: _horarios.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedHorario = newValue;
                        _filterTeachers(); // Re-filter when horario changes
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            const Text(
              'Lista de Professores',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.verdeUNICV,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: _filteredTeachers.isEmpty
                  ? Center(
                      child: Text(
                        _searchController.text.isEmpty && _selectedPeriodo == null && _selectedHorario == null
                            ? 'Utilize os filtros acima para buscar.'
                            : 'Nenhum professor encontrado com os filtros aplicados.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredTeachers.length,
                      itemBuilder: (context, index) {
                        return _buildTeacherListItem(_filteredTeachers[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
