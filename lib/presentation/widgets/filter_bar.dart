import 'package:flutter/material.dart';
import '../../core/enums.dart';

class FilterBar extends StatelessWidget {
  final TaskStatus? selected;
  final Function(TaskStatus?) onChanged;
  const FilterBar({super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ChoiceChip(
          label: const Text('To Do'),
          selected: selected == TaskStatus.todo,
          onSelected: (_) => onChanged(TaskStatus.todo),
        ),
        const SizedBox(width: 8),
        ChoiceChip(
          label: const Text('In Progress'),
          selected: selected == TaskStatus.inProgress,
          onSelected: (_) => onChanged(TaskStatus.inProgress),
        ),
        const SizedBox(width: 8),
        ChoiceChip(
          label: const Text('Done'),
          selected: selected == TaskStatus.done,
          onSelected: (_) => onChanged(TaskStatus.done),
        ),
      ],
    );
  }
}
