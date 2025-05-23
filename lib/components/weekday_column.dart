import 'package:flutter/material.dart';
import '../theme/theme.dart';
import 'widgets/schedule_card.dart';

class WeekdayColumn extends StatelessWidget {
  final String weekday;
  final List<Widget> scheduleCards;

  const WeekdayColumn({
    Key? key,
    required this.weekday,
    required this.scheduleCards,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;
    final bool isDesktop = width > 1024;
    final double fontSize = (width * 0.012).clamp(14.0, 20.0);

    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.verdeUNICV,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  weekday,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize * 1.2,
                  ),
                ),
                Text(
                  '${scheduleCards.length} horário(s)',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: fontSize * 0.9,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: scheduleCards.isEmpty
                ? Center(
                    child: Text(
                      'Nenhum horário cadastrado',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: fontSize,
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: scheduleCards,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
} 