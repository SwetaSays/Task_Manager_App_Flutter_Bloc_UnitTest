import '../../core/enums.dart';

class Task {
  final String id;
  final String title;
  final String? description;
  final TaskStatus status;
  final DateTime dueDate;
  final int order; 

  Task({
    required this.id,
    required this.title,
    this.description,
    this.status = TaskStatus.todo,
    required this.dueDate,
    this.order = 0,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    TaskStatus? status,
    DateTime? dueDate,
    int? order,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      order: order ?? this.order,
    );
  }
}
