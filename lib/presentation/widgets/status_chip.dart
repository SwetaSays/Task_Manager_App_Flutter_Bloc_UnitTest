import 'package:flutter/material.dart';
import '../../core/enums.dart';

class StatusChip extends StatelessWidget {
  final TaskStatus status;
  const StatusChip({super.key, required this.status});

  Color _colorForStatus(BuildContext context) {
    switch (status) {
      case TaskStatus.todo:
        return Colors.blue.shade300;
      case TaskStatus.inProgress:
        return Colors.orange.shade300;
      case TaskStatus.done:
        return Colors.green.shade300;
    }
  }

  IconData _iconForStatus() {
    switch (status) {
      case TaskStatus.todo:
        return Icons.radio_button_unchecked;
      case TaskStatus.inProgress:
        return Icons.autorenew;
      case TaskStatus.done:
        return Icons.check_circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _colorForStatus(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_iconForStatus(), size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            status.name,
            style: TextStyle(color: color.darken(), fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

extension ColorBrightness on Color {
  Color darken([double amount = .2]) {
    final f = 1 - amount;
    return Color.fromARGB(alpha, (red * f).round(), (green * f).round(), (blue * f).round());
  }
  int get alpha => this.alpha;
}
