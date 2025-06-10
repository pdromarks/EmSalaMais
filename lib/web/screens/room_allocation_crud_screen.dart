import 'package:em_sala_mais/backend/dto/room_allocation_dto.dart';
import 'package:em_sala_mais/backend/model/bloco.dart';
import 'package:em_sala_mais/backend/model/enums.dart';
import 'package:em_sala_mais/backend/model/room.dart';
import 'package:em_sala_mais/backend/model/room_allocation.dart';
import 'package:em_sala_mais/backend/model/schedule.dart';
import 'package:em_sala_mais/backend/model/schedule_teacher.dart';
import 'package:em_sala_mais/backend/services/bloco.service.dart';
import 'package:em_sala_mais/backend/services/room.service.dart';
import 'package:em_sala_mais/backend/services/room_allocation.service.dart';
import 'package:em_sala_mais/backend/services/schedule.service.dart';
import 'package:em_sala_mais/backend/services/schedule_teacher.service.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../../components/widgets/custom_date_field.dart';
import '../../components/widgets/custom_dropdown.dart';
import '../../components/widgets/custom_room_allocation_card.dart';
import '../../theme/theme.dart';
import 'package:intl/intl.dart';

class RoomAllocationCrudScreen extends StatefulWidget {
  const RoomAllocationCrudScreen({Key? key}) : super(key: key);

  @override
  _RoomAllocationCrudScreenState createState() =>
      _RoomAllocationCrudScreenState();
}

class _RoomAllocationCrudScreenState extends State<RoomAllocationCrudScreen> {
  // Estado da UI
  DateTime? _selectedDate;
  bool _isDateSelectionMode = true;
  bool _isLoading = true;
  String? _openFilterDropdown;

  // Serviços
  late final RoomAllocationService _roomAllocationService;
  late final RoomService _roomService;
  late final BlocoService _blocoService;
  late final ScheduleTeacherService _scheduleTeacherService;
  late final ScheduleService _scheduleService;

  // Listas de dados do backend
  List<RoomAllocation> _allAllocations = [];
  List<Room> _allRooms = [];
  List<Bloco> _allBlocos = [];
  List<ScheduleTeacher> _allScheduleTeachers = [];
  List<Schedule> _allSchedules = [];

  // Estado dos filtros
  String? _selectedPeriodo; // 'matutino', 'vespertino', 'noturno'
  ScheduleTime? _selectedHorario; // 'primeira', 'segunda'
  int? _selectedBlocoId;

  // Listas para os dropdowns de filtro (estáticas)
  final List<DropdownValueModel> _periodos = [
    DropdownValueModel(value: 'matutino', label: 'Matutino'),
    DropdownValueModel(value: 'vespertino', label: 'Vespertino'),
    DropdownValueModel(value: 'noturno', label: 'Noturno'),
  ];
  final List<DropdownValueModel> _horarios = [
    DropdownValueModel(value: 'primeira', label: 'Primeira Aula'),
    DropdownValueModel(value: 'segunda', label: 'Segunda Aula'),
  ];

  // Dados filtrados para exibição
  List<Room> _filteredRooms = [];
  List<ScheduleTeacher> _availableClasses = [];

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _fetchData();
  }

  void _initializeServices() {
    _roomAllocationService = RoomAllocationService();
    _roomService = RoomService();
    _blocoService = BlocoService();
    _scheduleTeacherService = ScheduleTeacherService();
    _scheduleService = ScheduleService();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    try {
      final allocations = await _roomAllocationService.getRoomAllocations();
      final rooms = await _roomService.getRooms();
      final blocos = await _blocoService.getBlocos();
      final scheduleTeachers =
          await _scheduleTeacherService.getScheduleTeachers();
      final schedules = await _scheduleService.getSchedules();

      setState(() {
        _allAllocations = allocations;
        _allRooms = rooms;
        _allBlocos = blocos;
        _allScheduleTeachers = scheduleTeachers;
        _allSchedules = schedules;
        _isLoading = false;
      });

      // Aplica os filtros com os dados carregados
      if (_selectedDate != null) {
        _applyFilters();
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados: $e')),
      );
    }
  }

  void _onDateSelectedForScreen(DateTime? date) {
    setState(() {
      _selectedDate = date;
      if (date != null) {
        _isDateSelectionMode = false;
        _applyFilters();
      }
    });
  }

  void _handleFilterDropdownOpen(String dropdownId) {
    setState(() {
      _openFilterDropdown =
          _openFilterDropdown == dropdownId ? null : dropdownId;
    });
  }

  void _applyFilters() {
    if (_selectedDate == null) return;
    setState(() {
      // 1. Filtrar salas pelo bloco selecionado
      _filteredRooms = _allRooms
          .where((room) =>
              _selectedBlocoId == null || room.bloco.id == _selectedBlocoId)
          .toList();

      // 2. Filtrar turmas disponíveis (ScheduleTeacher)
      _filterAvailableClasses();
    });
  }

  void _filterAvailableClasses() {
    if (_selectedDate == null ||
        _selectedPeriodo == null ||
        _selectedHorario == null) {
      _availableClasses = [];
      return;
    }

    final selectedDayOfWeek =
        DayOfWeek.values[_selectedDate!.weekday - 1]; // Monday is 1 -> index 0

    // Encontra o ID do Schedule correspondente ao período e horário
    final schedule = _allSchedules.firstWhereOrNull((s) =>
        s.periodoHora.toLowerCase() == _selectedPeriodo &&
        s.scheduleTime == _selectedHorario);

    if (schedule == null) {
      _availableClasses = [];
      return;
    }

    // Filtra ScheduleTeachers pelo dia da semana e ID do Schedule
    final applicableScheduleTeachers = _allScheduleTeachers
        .where((st) =>
            st.dayOfWeek == selectedDayOfWeek && st.schedule.id == schedule.id)
        .toList();

    // Filtra as alocações que são relevantes para o dia/horário atual
    final relevantAllocations = _allAllocations
        .where((alloc) =>
            alloc.scheduleTeacher.dayOfWeek == selectedDayOfWeek &&
            alloc.scheduleTeacher.schedule.id == schedule.id)
        .toList();
    
    final allocatedScheduleTeacherIds =
        relevantAllocations.map((alloc) => alloc.scheduleTeacher.id).toSet();

    // As turmas disponíveis são aquelas aplicáveis que ainda não foram alocadas
    _availableClasses = applicableScheduleTeachers
        .where((st) => !allocatedScheduleTeacherIds.contains(st.id))
        .toList();
  }

  Future<void> _onClassSelectedInCard(
      int roomId, int? scheduleTeacherId) async {
    if (_selectedDate == null || _selectedPeriodo == null || _selectedHorario == null) return;

    final selectedDayOfWeek = DayOfWeek.values[_selectedDate!.weekday - 1];
    final schedule = _allSchedules.firstWhereOrNull((s) =>
      s.periodoHora.toLowerCase() == _selectedPeriodo &&
      s.scheduleTime == _selectedHorario
    );

    if (schedule == null) return;

    // Encontra a alocação existente para esta sala neste dia/horário
    final existingAllocation = _allAllocations.firstWhereOrNull((alloc) =>
      alloc.room.id == roomId &&
      alloc.scheduleTeacher.dayOfWeek == selectedDayOfWeek &&
      alloc.scheduleTeacher.schedule.id == schedule.id
    );

    try {
      if (scheduleTeacherId == null) { // Desalocando
        if (existingAllocation != null) {
          await _roomAllocationService.deleteRoomAllocation(existingAllocation.id);
        }
      } else { // Alocando ou trocando
        if (existingAllocation != null && existingAllocation.scheduleTeacher.id != scheduleTeacherId) {
          // Se já existe uma alocação com outra turma, primeiro deleta a antiga
          await _roomAllocationService.deleteRoomAllocation(existingAllocation.id);
        }

        // Cria a nova alocação
        final dto = RoomAllocationDTO(
          roomId: roomId,
          scheduleTeacherId: scheduleTeacherId,
          updatedAt: DateTime.now(),
        );
        await _roomAllocationService.createRoomAllocation(dto);
      }
      await _fetchData(); // Recarrega todos os dados para refletir a mudança
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar alocação: $e')),
      );
    }
  }

  String _formatSemester(Semester s) {
    final idx = Semester.values.indexOf(s) + 1;
    return '${idx}º Sem';
  }

  String _getPeriodFromSemester(Semester s) {
    // Mapeamento do semestre para o período
    switch (s) {
      case Semester.primeiro:
      case Semester.segundo:
        return 'matutino';
      case Semester.terceiro:
      case Semester.quarto:
        return 'vespertino';
      case Semester.quinto:
      case Semester.sexto:
      case Semester.setimo:
      case Semester.oitavo:
      case Semester.nono:
      case Semester.decimo:
        return 'noturno';
      default:
        return 'noturno'; // Valor padrão
    }
  }

  Widget _buildDateSelectionForm() {
    final Size screenSize = MediaQuery.of(context).size;
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24.0),
        constraints: BoxConstraints(
            maxWidth: screenSize.width * (screenSize.width > 600 ? 0.4 : 0.8)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Selecionar Data para Alocação',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: AppColors.verdeUNICV)),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: const Icon(Icons.calendar_today, color: Colors.white),
              label: const Text('Selecionar Data', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                _onDateSelectedForScreen(picked);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.verdeUNICV,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersRow(BuildContext context) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 800;
    final double fieldWidth = isSmallScreen ? (screenSize.width / 2) - 12 : 200;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Wrap(
            spacing: 8.0,
            runSpacing: 12.0,
            children: [
              SizedBox(
                width: fieldWidth,
                child: CustomDropdown(
                  label: 'Período',
                  items: _periodos,
                  selectedValue:
                      _periodos.firstWhereOrNull((p) => p.value == _selectedPeriodo),
                  onChanged: (val) => setState(() {
                    _selectedPeriodo = val?.value;
                    _applyFilters();
                  }),
                  dropdownId: 'periodo_filter',
                ),
              ),
              SizedBox(
                width: fieldWidth,
                child: CustomDropdown(
                  label: 'Horário',
                  items: _horarios,
                  selectedValue: _horarios
                      .firstWhereOrNull((h) => h.value == _selectedHorario?.name),
                  onChanged: (val) => setState(() {
                    _selectedHorario =
                        val != null ? ScheduleTime.values.byName(val.value) : null;
                    _applyFilters();
                  }),
                  dropdownId: 'horario_filter',
                ),
              ),
              SizedBox(
                width: fieldWidth,
                child: CustomDropdown(
                  label: 'Bloco',
                  items: _allBlocos
                      .map((b) => DropdownValueModel(value: b.id.toString(), label: b.name))
                      .toList(),
                  selectedValue: _allBlocos
                      .map((b) => DropdownValueModel(value: b.id.toString(), label: b.name))
                      .firstWhereOrNull((d) => d.value == _selectedBlocoId.toString()),
                  onChanged: (val) => setState(() {
                    _selectedBlocoId = val != null ? int.tryParse(val.value) : null;
                    _applyFilters();
                  }),
                  dropdownId: 'bloco_filter',
                  showClearButton: true,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 180,
          child: InkWell(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null && picked != _selectedDate) {
                setState(() {
                  _selectedDate = picked;
                  _applyFilters();
                });
              }
            },
            borderRadius: BorderRadius.circular(20.0),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'Data',
                labelStyle: const TextStyle(
                  color: AppColors.verdeUNICV,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                contentPadding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: AppColors.verdeUNICV, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: AppColors.verdeUNICV, width: 2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate != null ? formatter.format(_selectedDate!) : '',
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.calendar_today, color: AppColors.verdeUNICV, size: 24),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoomsGrid() {
    if (_selectedDate == null || _selectedPeriodo == null || _selectedHorario == null) {
      return const Center(child: Padding(
        padding: EdgeInsets.all(32.0),
        child: Text('Por favor, selecione data, período e horário para ver as salas.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
      ));
    }

    if (_filteredRooms.isEmpty) {
      return const Center(
          child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text('Nenhuma sala encontrada para os filtros selecionados.',
                  textAlign: TextAlign.center)));
    }

    final schedule = _allSchedules.firstWhereOrNull((s) =>
      s.periodoHora.toLowerCase() == _selectedPeriodo &&
      s.scheduleTime == _selectedHorario);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), // GridView within SingleChildScrollView
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 400.0, // Largura máxima de cada card
        mainAxisSpacing: 12.0,
        crossAxisSpacing: 12.0,
        childAspectRatio: 0.9, // Proporção Altura/Largura do card
      ),
      itemCount: _filteredRooms.length,
      itemBuilder: (context, index) {
        final room = _filteredRooms[index];
        final allocation = _allAllocations.firstWhereOrNull((alloc) =>
            alloc.room.id == room.id &&
            alloc.scheduleTeacher.schedule.id == schedule?.id &&
            alloc.scheduleTeacher.dayOfWeek ==
                DayOfWeek.values[_selectedDate!.weekday - 1]);

        // A lista de turmas para o dropdown inclui as já disponíveis + a que está alocada nesta sala (se houver)
        final List<ScheduleTeacher> dropdownClasses = [..._availableClasses];
        if (allocation != null &&
            !dropdownClasses.any((st) => st.id == allocation.scheduleTeacher.id)) {
          dropdownClasses.add(allocation.scheduleTeacher);
        }

        final dropdownItems = dropdownClasses.map((st) {
          final period = _getPeriodFromSemester(st.group.semester);
          final capitalizedPeriod = period.replaceFirstMapped(
              RegExp(r'(\w)'), (m) => m.group(1)!.toUpperCase());
          return DropdownValueModel(
            value: st.id.toString(),
            label:
                '${st.group.course.name} - ${_formatSemester(st.group.semester)} - Turma ${st.group.name} - $capitalizedPeriod',
          );
        }).toList();

        if (allocation != null) {
          dropdownItems.insert(
              0,
              DropdownValueModel(
                  value: 'unallocate', label: '--- Remover Alocação ---'));
        }

        return CustomRoomAllocationCard(
          roomId: room.id.toString(),
          roomName: room.name,
          roomBlock: room.bloco.name,
          roomDesksCount: room.chairsNumber ?? 0,
          roomHasTV: room.hasTv,
          roomHasProjector: room.hasProjector,
          availableClasses: dropdownItems,
          selectedClassValue: dropdownItems.firstWhereOrNull(
              (d) => d.value == allocation?.scheduleTeacher.id.toString()),
          enableClassSearch: true,
          allowClear: true, // Permite limpar a alocação
          allocatedClassDetails: allocation != null
              ? AllocatedClassDetails(
                  teacher: allocation.scheduleTeacher.teacher.name,
                  subject: allocation.scheduleTeacher.subject.name,
                  time: '${schedule!.scheduleStart} - ${schedule.scheduleEnd}',
                )
              : null,
          onClassSelected: (roomId, selectedClass) {
            if (selectedClass?.value == 'unallocate') {
              _onClassSelectedInCard(int.parse(roomId), null);
            } else {
              _onClassSelectedInCard(
                  int.parse(roomId),
                  selectedClass != null
                      ? int.parse(selectedClass.value)
                      : null);
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xfff1f1f1),
      body: _isDateSelectionMode
          ? _buildDateSelectionForm()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alocação de Salas',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.verdeUNICV,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildFiltersRow(context),
                  const SizedBox(height: 24),
                  _buildRoomsGrid(),
                ],
              ),
            ),
    );
  }
}
