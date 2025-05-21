import 'package:flutter/material.dart';
import '../theme/theme.dart';

class CustomRoomCard extends StatelessWidget {
  final String name;
  final String block;
  final int desksCount;
  final bool hasTV;
  final bool hasProjector;
  final Function() onEdit;
  final Function() onDelete;

  const CustomRoomCard({
    super.key,
    required this.name,
    required this.block,
    required this.desksCount,
    required this.hasTV,
    required this.hasProjector,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;
    final bool isDesktop = width > 1024;
    final double fontSize = (width * 0.04).clamp(14.0, 20.0);
    
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nome da Sala
            Text(
              name,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: AppColors.verdeUNICV,
              ),
            ),
            const SizedBox(height: 4),
            
            // Bloco
            Row(
              children: [
                Icon(
                  Icons.apartment,
                  size: fontSize * 0.9,
                  color: Colors.grey[700],
                ),
                const SizedBox(width: 4),
                Text(
                  'Bloco: $block',
                  style: TextStyle(
                    fontSize: fontSize * 0.85,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Informações com Ícones
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Carteiras
                Row(
                  children: [
                    Icon(
                      Icons.chair,
                      size: fontSize * 1.2,
                      color: AppColors.verdeUNICV,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$desksCount',
                      style: TextStyle(
                        fontSize: fontSize * 0.85,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                
                // TV
                Column(
                  children: [
                    Icon(
                      Icons.tv,
                      size: fontSize * 1.2,
                      color: hasTV ? AppColors.verdeUNICV : Colors.grey,
                    ),
                    Text(
                      'TV',
                      style: TextStyle(
                        fontSize: fontSize * 0.7,
                        color: hasTV ? AppColors.verdeUNICV : Colors.grey,
                      ),
                    ),
                  ],
                ),
                
                // Projetor
                Column(
                  children: [
                    Icon(
                      Icons.videocam,
                      size: fontSize * 1.2,
                      color: hasProjector ? AppColors.verdeUNICV : Colors.grey,
                    ),
                    Text(
                      'Projetor',
                      style: TextStyle(
                        fontSize: fontSize * 0.7,
                        color: hasProjector ? AppColors.verdeUNICV : Colors.grey,
                      ),
                    ),
                  ],
                ),
                
                // Ações
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: AppColors.verdeUNICV,
                        size: fontSize * 1.1,
                      ),
                      onPressed: onEdit,
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: fontSize * 1.1,
                      ),
                      onPressed: onDelete,
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 