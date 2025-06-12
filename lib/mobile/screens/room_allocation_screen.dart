import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../components/widgets/custom_dropdown.dart';
import '../../backend/services/room_allocation.service.dart';
import '../../backend/services/mobile_user.service.dart';
import '../../backend/model/room_allocation.dart';
import '../../backend/model/enums.dart';
import '../../backend/dto/mobile_user_dto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../backend/model/mobile_user.dart';

class RoomAllocationScreen extends StatefulWidget {
  const RoomAllocationScreen({super.key});

  @override
  State<RoomAllocationScreen> createState() => _RoomAllocationScreenState();
}

class _RoomAllocationScreenState extends State<RoomAllocationScreen> {
  final _roomAllocationService = RoomAllocationService();
  final _mobileUserService = MobileUserService();
  final _supabase = Supabase.instance.client;
  
  String _currentDayOfWeek = '';
  bool _isLoading = true;
  String? _error;
  List<RoomAllocation> _todaysAllocations = [];

  @override
  void initState() {
    super.initState();
    _setCurrentDayOfWeek();
    _fetchAllocations();
  }

  void _setCurrentDayOfWeek() {
    final now = DateTime.now();
    final weekday = now.weekday;
    setState(() {
      _currentDayOfWeek = _getWeekdayInPortuguese(weekday);
    });
  }

  String _getWeekdayInPortuguese(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Segunda-feira';
      case DateTime.tuesday:
        return 'Terça-feira';
      case DateTime.wednesday:
        return 'Quarta-feira';
      case DateTime.thursday:
        return 'Quinta-feira';
      case DateTime.friday:
        return 'Sexta-feira';
      case DateTime.saturday:
        return 'Sábado';
      case DateTime.sunday:
        return 'Domingo';
      default:
        return '';
    }
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

      // Busca todas as alocações
      final allAllocations = await _roomAllocationService.getRoomAllocations();
      
      // Filtra apenas as alocações do dia atual e da turma do usuário
      final today = DateTime.now();
      final currentDayOfWeek = DayOfWeek.values[today.weekday - 1];
      
      setState(() {
        _todaysAllocations = allAllocations
            .where((alloc) => 
              alloc.scheduleTeacher.group.id == mobileUser.idGroup &&
              alloc.scheduleTeacher.dayOfWeek == currentDayOfWeek)
            .toList();

        // Ordena por horário de início
        _todaysAllocations.sort((a, b) => 
          a.scheduleTeacher.schedule.scheduleStart.compareTo(
            b.scheduleTeacher.schedule.scheduleStart
          )
        );
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

  Widget _buildAllocationCard(RoomAllocation allocation) {
    final schedule = allocation.scheduleTeacher.schedule;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
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
              'Disciplina: ${allocation.scheduleTeacher.subject.name}',
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
                  'Sala: ${allocation.room.name} (${allocation.room.bloco.name})',
                  style: const TextStyle(color: Colors.black87),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                const Icon(Icons.person_outline, color: Colors.grey, size: 20),
                const SizedBox(width: 8.0),
                Text(
                  'Professor: ${allocation.scheduleTeacher.teacher.name}',
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
                  'Horário: ${schedule.scheduleStart} - ${schedule.scheduleEnd}',
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
    final double titleFontSize = (width * 0.05).clamp(18.0, 24.0);
    final double dayFontSize = (width * 0.08).clamp(24.0, 32.0);

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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: height * 0.03,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              _currentDayOfWeek,
              style: TextStyle(
                fontSize: dayFontSize,
                fontWeight: FontWeight.bold,
                color: AppColors.verdeUNICV,
                fontFamily: 'Inter',
              ),
            ),
            SizedBox(height: verticalSpacing * 2),
            if (_todaysAllocations.isEmpty)
              Center(
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
                      'Não há aula cadastrada para hoje :D',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        color: AppColors.verdeUNICV,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              ..._todaysAllocations.map((allocation) {
                final isFirstClass = allocation.scheduleTeacher.schedule.scheduleTime == ScheduleTime.primeira;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isFirstClass ? '1ª Aula' : '2ª Aula',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.w600,
                        color: AppColors.verdeUNICV,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    _buildAllocationCard(allocation),
                    SizedBox(height: verticalSpacing * 2),
                  ],
                );
              }).toList(),
          ],
        ),
      ),
    );
  }
}
