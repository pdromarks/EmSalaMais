import 'package:flutter/material.dart';
import '../theme/theme.dart';

class ScheduleCard extends StatelessWidget {
  final String course;
  final String semester;
  final String period;
  final String className;
  final String teacher;
  final String subject;
  final String time;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ScheduleCard({
    Key? key,
    required this.course,
    required this.semester,
    required this.period,
    required this.className,
    required this.teacher,
    required this.subject,
    required this.time,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;
    final bool isDesktop = width > 1024;
    final bool isTablet = width > 600 && width <= 1024;
    final double fontSize = (width * (isDesktop ? 0.012 : isTablet ? 0.016 : 0.04))
        .clamp(14.0, 20.0);

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Horário em destaque
            Text(
              time,
              style: TextStyle(
                fontSize: fontSize * 1.4,
                fontWeight: FontWeight.bold,
                color: AppColors.verdeUNICV,
              ),
            ),
            const SizedBox(height: 8),

            // Período
            Text(
              period,
              style: TextStyle(
                fontSize: fontSize * 0.9,
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),

            // Curso
            Text(
              course,
              style: TextStyle(
                fontSize: fontSize * 0.9,
                color: Colors.grey[800],
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),

            // Semestre e Turma
            Row(
              children: [
                Text(
                  semester,
                  style: TextStyle(
                    fontSize: fontSize * 0.9,
                    color: Colors.grey[600],
                  ),
                ),
                const Spacer(),
                Text(
                  'Turma: $className',
                  style: TextStyle(
                    fontSize: fontSize * 0.9,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Professor
            Row(
              children: [
                Icon(
                  Icons.person,
                  size: fontSize,
                  color: Colors.grey[700],
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    teacher,
                    style: TextStyle(
                      fontSize: fontSize * 0.9,
                      color: Colors.grey[800],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Disciplina
            Row(
              children: [
                Icon(
                  Icons.book,
                  size: fontSize,
                  color: Colors.grey[700],
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    subject,
                    style: TextStyle(
                      fontSize: fontSize * 0.9,
                      color: Colors.grey[800],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Botões de ação
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: AppColors.verdeUNICV,
                    size: fontSize * 1.1,
                  ),
                  onPressed: onEdit,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  padding: EdgeInsets.zero,
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: fontSize * 1.1,
                  ),
                  onPressed: onDelete,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 