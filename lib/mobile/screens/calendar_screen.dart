import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../theme/theme.dart';
import '../../backend/services/room_allocation.service.dart';
import '../../backend/services/mobile_user.service.dart';
import '../../backend/model/room_allocation.dart';
import '../../backend/model/enums.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Aula {
  final String disciplina;
  final String professor;
  final String sala;
  final String bloco;
  final String horario;
  final ScheduleTime scheduleTime;
  final DayOfWeek dayOfWeek;

  Aula({
    required this.disciplina,
    required this.professor,
    required this.sala,
    required this.bloco,
    required this.horario,
    required this.scheduleTime,
    required this.dayOfWeek,
  });
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final _roomAllocationService = RoomAllocationService();
  final _mobileUserService = MobileUserService();
  final _supabase = Supabase.instance.client;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Aula>> _events = {};
  bool _isLoading = true;
  String? _error;
  int? _userGroupId;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _fetchAllocations();
  }

  Future<void> _fetchAllocations() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Busca o usuário atual e sua turma
      final userId = _supabase.auth.currentUser!.id;
      final mobileUser = await _mobileUserService.getMobileUserByAuthId(userId);
      if (mobileUser == null) {
        throw Exception('Usuário não encontrado');
      }

      // Armazena o ID da turma do usuário
      _userGroupId = mobileUser.idGroup;

      // Busca todas as alocações
      final allAllocations = await _roomAllocationService.getRoomAllocations();
      
      // Filtra apenas as alocações da turma do usuário
      final userAllocations = allAllocations
          .where((alloc) => alloc.scheduleTeacher.group.id == _userGroupId)
          .toList();

      // Organiza as alocações por dia da semana
      final Map<DateTime, List<Aula>> events = {};
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 0);

      // Para cada dia do mês
      for (var date = startOfMonth; date.isBefore(endOfMonth.add(const Duration(days: 1))); date = date.add(const Duration(days: 1))) {
        // Pega o dia da semana (1 = segunda, 7 = domingo)
        final weekday = date.weekday;
        
        // Ignora sábado e domingo
        if (weekday > 5) continue;

        // Filtra alocações para este dia da semana
        final dayOfWeek = DayOfWeek.values[weekday - 1];
        final dayAllocations = userAllocations
            .where((alloc) => alloc.scheduleTeacher.dayOfWeek == dayOfWeek)
            .toList();

        // Ordena por horário
        dayAllocations.sort((a, b) => 
          a.scheduleTeacher.schedule.scheduleStart.compareTo(
            b.scheduleTeacher.schedule.scheduleStart
          )
        );

        // Converte para o formato Aula
        final aulas = dayAllocations.map((alloc) => Aula(
          disciplina: alloc.scheduleTeacher.subject.name,
          professor: alloc.scheduleTeacher.teacher.name,
          sala: alloc.room.name,
          bloco: alloc.room.bloco.name,
          horario: '${alloc.scheduleTeacher.schedule.scheduleStart} - ${alloc.scheduleTeacher.schedule.scheduleEnd}',
          scheduleTime: alloc.scheduleTeacher.schedule.scheduleTime,
          dayOfWeek: alloc.scheduleTeacher.dayOfWeek,
        )).toList();

        if (aulas.isNotEmpty) {
          events[DateTime(date.year, date.month, date.day)] = aulas;
        }
      }

      setState(() {
        _events = events;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  List<Aula> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }
  }

  String _getDayOfWeekName(DayOfWeek day) {
    switch (day) {
      case DayOfWeek.segunda:
        return 'Segunda-feira';
      case DayOfWeek.terca:
        return 'Terça-feira';
      case DayOfWeek.quarta:
        return 'Quarta-feira';
      case DayOfWeek.quinta:
        return 'Quinta-feira';
      case DayOfWeek.sexta:
        return 'Sexta-feira';
      default:
        return '';
    }
  }

  Widget _buildEventCard(Aula aula) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              aula.disciplina,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12.0),
            Row(
              children: [
                const Icon(Icons.person_outline, color: Colors.grey, size: 20),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    aula.professor,
                    style: const TextStyle(color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                const Icon(Icons.room_outlined, color: Colors.grey, size: 20),
                const SizedBox(width: 8.0),
                Text(
                  '${aula.sala} (${aula.bloco})',
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
                  aula.horario,
                  style: const TextStyle(color: Colors.black87),
                ),
                const SizedBox(width: 16.0),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: AppColors.verdeUNICV.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    aula.scheduleTime == ScheduleTime.primeira ? '1ª Aula' : '2ª Aula',
                    style: TextStyle(
                      color: AppColors.verdeUNICV,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
    final List<Aula> selectedDayEvents = _selectedDay != null ? _getEventsForDay(_selectedDay!) : [];
    final double horizontalPadding = screenSize.width * 0.08;

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
                onPressed: _fetchAllocations,
                child: const Text('Tentar Novamente'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xfff1f1f1),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: screenSize.height * 0.03,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Calendário',
              style: TextStyle(
                fontSize: (screenSize.width * 0.08).clamp(24.0, 32.0),
                fontWeight: FontWeight.w800,
                color: AppColors.verdeUNICV,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 20.0),
            TableCalendar<Aula>(
              locale: 'pt_BR',
              firstDay: DateTime(DateTime.now().year, DateTime.now().month - 3, 1),
              lastDay: DateTime(DateTime.now().year, DateTime.now().month + 3, 0),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: _onDaySelected,
              eventLoader: _getEventsForDay,
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              headerStyle: HeaderStyle(
                titleTextStyle: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.black87,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
                formatButtonVisible: true,
                titleCentered: true,
                leftChevronIcon: const Icon(Icons.chevron_left, color: AppColors.verdeUNICV),
                rightChevronIcon: const Icon(Icons.chevron_right, color: AppColors.verdeUNICV),
              ),
              calendarStyle: CalendarStyle(
                outsideDaysVisible: true,
                todayDecoration: BoxDecoration(
                  color: AppColors.verdeUNICV.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: AppColors.verdeUNICV,
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: AppColors.verdeUNICV.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                markerSize: 5.0,
                markersAlignment: Alignment.bottomCenter,
              ),
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  color: Colors.black54,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
                weekendStyle: TextStyle(
                  color: AppColors.verdeUNICV,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
              availableCalendarFormats: const {
                CalendarFormat.month: 'Mês',
                CalendarFormat.week: 'Semana',
              },
            ),
            if (selectedDayEvents.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                child: Text(
                  _getDayOfWeekName(selectedDayEvents.first.dayOfWeek),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.verdeUNICV,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
            Expanded(
              child: selectedDayEvents.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.event_busy,
                            size: 64,
                            color: AppColors.verdeUNICV,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Não há aulas cadastradas para este dia :D',
                            style: TextStyle(
                              fontSize: (screenSize.width * 0.04).clamp(14.0, 18.0),
                              color: Colors.grey[600],
                              fontFamily: 'Inter',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: selectedDayEvents.length,
                      itemBuilder: (context, index) {
                        return _buildEventCard(selectedDayEvents[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
