import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:table_calendar/table_calendar.dart';
import '../../theme/theme.dart'; // Your app's theme

// Model for a class/event (can be expanded)
class Aula {
  final String title;
  final String time;
  final String? details; // e.g., Professor, Sala

  Aula({required this.title, required this.time, this.details});
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Aula>> _events = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    // Load mock events - In a real app, fetch this from a service
    _loadMockEvents();
    // Initialize DateFormat for Portuguese locale
    // This is often done in main.dart using initializeDateFormatting
    // For simplicity here, ensure 'pt_BR' is available or use default.
  }

  void _loadMockEvents() {
    // Example mock data
    final today = DateTime.now();
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final dayAfterTomorrow = DateTime.now().add(const Duration(days: 2));
    final aWeekLater = DateTime.now().add(const Duration(days: 7));

    _events = {
      DateTime(today.year, today.month, today.day): [
        Aula(title: 'Cálculo I', time: '08:00 - 09:40', details: 'Prof. Silva - Sala 101'),
        Aula(title: 'Algoritmos', time: '10:00 - 11:40', details: 'Profa. Ana - Lab. II'),
      ],
      DateTime(tomorrow.year, tomorrow.month, tomorrow.day): [
        Aula(title: 'Física Experimental', time: '14:00 - 15:40', details: 'Lab. Física'),
      ],
      DateTime(aWeekLater.year, aWeekLater.month, aWeekLater.day -2): [
         Aula(title: 'PERÍODO DE PROVAS GRADUAÇÃO (2º Bimestre)', time: 'Evento', details: 'Prova de 2ª CHAMADA GRADUAÇÃO (2º Bimestre): Inscrições'),
      ],
       DateTime(aWeekLater.year, aWeekLater.month, aWeekLater.day): [
         Aula(title: 'PROVA DE 2ª CHAMADA GRADUAÇÃO (2º Bimestre): Inscrições', time: 'Evento', details: 'Prova de 2ª CHAMADA GRADUAÇÃO (2º Bimestre): Inscrições'),
      ]
    };
    setState(() {});
  }

  List<Aula> _getEventsForDay(DateTime day) {
    // Normalize day to avoid issues with time component
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return _events[normalizedDay] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }
  }

  Widget _buildEventCard(Aula aula) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 80, // Adjust height as needed or make it dynamic
            decoration: BoxDecoration(
              color: AppColors.verdeUNICV, // Or another color for events
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    aula.time == 'Evento' ? 'Evento' : aula.title, // Differentiate "Evento" title
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.verdeUNICV,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 4.0),
                   Text(
                    aula.time == 'Evento' ? aula.title : aula.time, // Show title as description for "Evento"
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontFamily: 'Inter'),
                  ),
                  if (aula.details != null && aula.time != 'Evento') ...[
                    const SizedBox(height: 4.0),
                    Text(
                      aula.details!,
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          fontFamily: 'Inter'),
                    ),
                  ],
                   if (aula.details != null && aula.time == 'Evento') ...[ // Show details if it's an "Evento"
                    const SizedBox(height: 4.0),
                    Text(
                      aula.details!,
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          fontFamily: 'Inter'),
                    ),
                  ]
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final List<Aula> selectedDayEvents = _selectedDay != null ? _getEventsForDay(_selectedDay!) : [];
    final double horizontalPadding = screenSize.width * 0.05;

    return Scaffold(
      backgroundColor: const Color(0xfff1f1f1),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Calendário',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.verdeUNICV,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: TableCalendar<Aula>(
                locale: 'pt_BR',
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
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
                  titleTextStyle: TextStyle(fontSize: 18.0, color: Colors.black87, fontFamily: 'Inter', fontWeight: FontWeight.w600),
                  formatButtonVisible: false, // Hides the format button (Month/2 weeks/Week)
                  titleCentered: true,
                  leftChevronIcon: Icon(Icons.chevron_left, color: AppColors.verdeUNICV),
                  rightChevronIcon: Icon(Icons.chevron_right, color: AppColors.verdeUNICV),
                ),
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
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
                   markersAlignment: Alignment.bottomCenter, // As in the image
                   // Adjust marker offset if needed
                   // markersOffset: const MarkersOffset(bottom: 3.5), // Commented out due to unresolved class name
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: Colors.black54, fontFamily: 'Inter', fontWeight: FontWeight.w500),
                  weekendStyle: TextStyle(color: AppColors.verdeUNICV, fontFamily: 'Inter', fontWeight: FontWeight.w500), // Highlight weekends
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
                child: selectedDayEvents.isNotEmpty
                    ? ListView.builder(
                        itemCount: selectedDayEvents.length,
                        itemBuilder: (context, index) {
                          return _buildEventCard(selectedDayEvents[index]);
                        },
                      )
                    : Center(
                        child: Text(
                          'Dia sem ensalamento :(',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontFamily: 'Inter'),
                        ),
                      ),
              ),
            ),
             const SizedBox(height: 16.0), // Padding at the bottom
          ],
        ),
      ),
    );
  }
}
