import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../components/widgets/custom_dropdown.dart';
import '../../components/widgets/custom_tf.dart';
import '../../backend/services/schedule_teacher.service.dart';
import '../../backend/services/room_allocation.service.dart';
import '../../backend/model/schedule_teacher.dart';
import '../../backend/model/room_allocation.dart';
import '../../backend/model/enums.dart';
import '../../backend/model/room.dart';
import '../../backend/model/bloco.dart';

class SearchTeacherScreen extends StatefulWidget {
  const SearchTeacherScreen({super.key});

  @override
  State<SearchTeacherScreen> createState() => _SearchTeacherScreenState();
}

class _SearchTeacherScreenState extends State<SearchTeacherScreen> {
  final _scheduleTeacherService = ScheduleTeacherService();
  final _roomAllocationService = RoomAllocationService();
  final _searchController = TextEditingController();
  
  bool _isLoading = true;
  String? _error;
  String? _openDropdownId;

  // Dados do backend
  List<ScheduleTeacher> _allSchedules = [];
  List<RoomAllocation> _allAllocations = [];
  
  // Valores selecionados
  DropdownValueModel? _selectedPeriodo;
  DropdownValueModel? _selectedHorario;

  // Listas para os dropdowns
  final List<DropdownValueModel> _periodos = [
    DropdownValueModel(value: 'matutino', label: 'Matutino'),
    DropdownValueModel(value: 'vespertino', label: 'Vespertino'),
    DropdownValueModel(value: 'noturno', label: 'Noturno'),
  ];

  final List<DropdownValueModel> _horarios = [
    DropdownValueModel(value: 'primeira', label: '1ª Aula'),
    DropdownValueModel(value: 'segunda', label: '2ª Aula'),
  ];

  @override
  void initState() {
    super.initState();
    _fetchData();
    _searchController.addListener(_filterTeachers);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterTeachers);
    _searchController.dispose();
    super.dispose();
  }

  void _filterTeachers() {
    // Força uma atualização da UI quando o texto de busca muda
    setState(() {});
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final schedules = await _scheduleTeacherService.getScheduleTeachers();
      final allocations = await _roomAllocationService.getRoomAllocations();
      
      setState(() {
        _allSchedules = schedules;
        _allAllocations = allocations;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _handleDropdownOpen(String dropdownId) {
    setState(() {
      _openDropdownId = _openDropdownId == dropdownId ? null : dropdownId;
    });
  }

  List<Map<String, dynamic>> _getFilteredTeachers() {
    if (_allSchedules.isEmpty) return [];

    final today = DateTime.now();
    final currentDayOfWeek = DayOfWeek.values[today.weekday - 1];
    
    // Filtra os horários pelo dia atual e filtros selecionados
    var filteredSchedules = _allSchedules.where((schedule) {
      final matchesDay = schedule.dayOfWeek == currentDayOfWeek;
      final matchesPeriod = _selectedPeriodo == null || 
        schedule.schedule.periodoHora.toLowerCase() == _selectedPeriodo!.value;
      final matchesTime = _selectedHorario == null || 
        schedule.schedule.scheduleTime.name == _selectedHorario!.value;
      final matchesSearch = _searchController.text.isEmpty || 
        schedule.teacher.name.toLowerCase().contains(_searchController.text.toLowerCase());
      
      return matchesDay && matchesPeriod && matchesTime && matchesSearch;
    }).toList();

    // Para cada horário, busca a sala alocada
    return filteredSchedules.map((schedule) {
      final allocation = _allAllocations.firstWhere(
        (alloc) => 
          alloc.scheduleTeacher.id == schedule.id &&
          alloc.scheduleTeacher.dayOfWeek == currentDayOfWeek,
        orElse: () => RoomAllocation(
          id: -1,
          room: Room(
            id: -1,
            name: 'Sala não definida',
            bloco: Bloco(id: -1, name: ''),
            chairsNumber: 0,
            hasTv: false,
            hasProjector: false,
          ),
          scheduleTeacher: schedule,
        ),
      );

      return {
        'professor': schedule.teacher.name,
        'sala': allocation.room.name,
        'bloco': allocation.room.bloco.name,
        'horario': '${schedule.schedule.scheduleStart} - ${schedule.schedule.scheduleEnd}',
      };
    }).toList();
  }

  Widget _buildTeacherListItem(Map<String, dynamic> teacherData) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              teacherData['professor'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12.0),
            Row(
              children: [
                const Icon(Icons.room_outlined, color: Colors.grey, size: 20),
                const SizedBox(width: 8.0),
                Text(
                  '${teacherData['sala']} (${teacherData['bloco']})',
                  style: const TextStyle(color: Colors.black87),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.grey, size: 20),
                const SizedBox(width: 8.0),
                Text(
                  teacherData['horario'],
                  style: const TextStyle(color: Colors.black87),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;
    final double height = screenSize.height;

    final double horizontalPadding = width * 0.08;
    final double verticalSpacing = height * 0.02;
    final double inputFontSize = (width * 0.04).clamp(14.0, 18.0);

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
              TextButton(
                onPressed: _fetchData,
                child: const Text('Tentar Novamente'),
              ),
            ],
          ),
        ),
      );
    }

    final filteredTeachers = _getFilteredTeachers();

    return Scaffold(
      backgroundColor: const Color(0xfff1f1f1),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: height * 0.03,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Buscar Professores',
              style: TextStyle(
                fontSize: (width * 0.08).clamp(24.0, 32.0),
                fontWeight: FontWeight.w800,
                color: AppColors.verdeUNICV,
                fontFamily: 'Inter',
              ),
            ),
            SizedBox(height: verticalSpacing * 1.5),
            CustomTextField(
              controller: _searchController,
              label: 'Nome do Professor',
              borderColor: AppColors.verdeUNICV,
              labelColor: AppColors.verdeUNICV,
              fontSize: inputFontSize,
              prefixIcon: Icons.search,
              iconColor: AppColors.verdeUNICV,
            ),
            SizedBox(height: verticalSpacing),
            Row(
              children: [
                Expanded(
                  child: CustomDropdown(
                    label: 'Período',
                    fontSize: inputFontSize,
                    items: _periodos,
                    selectedValue: _selectedPeriodo,
                    onChanged: (value) => setState(() {
                      _selectedPeriodo = value;
                      _filterTeachers();
                    }),
                    onOpen: () => _handleDropdownOpen('periodo'),
                    dropdownId: 'periodo',
                    openDropdownId: _openDropdownId,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: CustomDropdown(
                    label: 'Horário',
                    fontSize: inputFontSize,
                    items: _horarios,
                    selectedValue: _selectedHorario,
                    onChanged: (value) => setState(() {
                      _selectedHorario = value;
                      _filterTeachers();
                    }),
                    onOpen: () => _handleDropdownOpen('horario'),
                    dropdownId: 'horario',
                    openDropdownId: _openDropdownId,
                  ),
                ),
              ],
            ),
            SizedBox(height: verticalSpacing * 2),
            Text(
              'Lista de Professores',
              style: TextStyle(
                fontSize: inputFontSize * 1.2,
                fontWeight: FontWeight.w600,
                color: AppColors.verdeUNICV,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: filteredTeachers.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.search_off,
                            size: 64,
                            color: AppColors.verdeUNICV,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _searchController.text.isEmpty &&
                                    _selectedPeriodo == null &&
                                    _selectedHorario == null
                                ? 'Utilize os filtros acima para buscar professores.'
                                : 'Nenhum professor encontrado com os filtros aplicados.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: inputFontSize,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredTeachers.length,
                      itemBuilder: (context, index) {
                        return _buildTeacherListItem(
                          filteredTeachers[index],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
