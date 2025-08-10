import 'package:flutter/material.dart';
import '../../domain/entities/task.dart';
import '../../core/enums.dart';
import 'status_chip.dart';
import 'package:intl/intl.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat.yMMMd().format(task.dueDate);
    final isOverdue = task.dueDate.isBefore(DateTime.now()) && task.status != TaskStatus.done;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Status chip
        StatusChip(status: task.status),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              if (task.description != null && task.description!.isNotEmpty)
                Text(task.description!, maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: isOverdue ? Colors.red : Colors.grey),
                  const SizedBox(width: 6),
                  Text(dateLabel,
                      style: TextStyle(color: isOverdue ? Colors.red : Colors.grey, fontSize: 12)),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
