import 'package:flutter/material.dart';

import '../../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final ValueChanged<String> onStatusChanged;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onStatusChanged,
    required this.onEdit,
    required this.onDelete,
  });

  Color _getStatusColor() {
    switch (task.status) {
      case 'TODO':
        return const Color(0xFFE69A35);
      case 'IN_PROGRESS':
        return const Color(0xFF4285E8);
      case 'DONE':
        return const Color(0xFF35A875);
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel() {
    switch (task.status) {
      case 'TODO':
        return 'To Do';
      case 'IN_PROGRESS':
        return 'In Progress';
      case 'DONE':
        return 'Done';
      default:
        return task.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 7,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 4,
              height: 65,
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF252530),
                    ),
                  ),
                  if (task.description != null &&
                      task.description!.isNotEmpty) ...[
                    const SizedBox(height: 5),
                    Text(
                      task.description!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF888894),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getStatusLabel(),
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(
                Icons.more_horiz,
                color: Color(0xFF888894),
              ),
              onSelected: (value) {
                switch (value) {
                  case 'EDIT':
                    onEdit();
                    break;
                  case 'DELETE':
                    onDelete();
                    break;
                  default:
                    onStatusChanged(value);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'EDIT',
                  child: Text('Edit'),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: 'TODO',
                  child: Text('To Do'),
                ),
                const PopupMenuItem(
                  value: 'IN_PROGRESS',
                  child: Text('In Progress'),
                ),
                const PopupMenuItem(
                  value: 'DONE',
                  child: Text('Done'),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: 'DELETE',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, color: Colors.red),
                      SizedBox(width: 8),
                      Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}