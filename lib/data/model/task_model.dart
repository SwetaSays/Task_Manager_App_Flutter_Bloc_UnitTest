import 'dart:convert';
import 'package:equatable/equatable.dart';
import '../../domain/entities/task.dart';
import '../../core/enums.dart';

class TaskModel extends Task with EquatableMixin {
  TaskModel({
    required String id,
    required String title,
    String? description,
    TaskStatus status = TaskStatus.todo,
    required DateTime dueDate,
    int order = 0,
  }) : super(
          id: id,
          title: title,
          description: description,
          status: status,
          dueDate: dueDate,
          order: order,
        );

  factory TaskModel.fromEntity(Task t) {
    return TaskModel(
      id: t.id,
      title: t.title,
      description: t.description,
      status: t.status,
      dueDate: t.dueDate,
      order: t.order,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status.index,
      'dueDate': dueDate.toIso8601String(),
      'order': order,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      status: TaskStatus.values[map['status'] as int],
      dueDate: DateTime.parse(map['dueDate'] as String),
      order: map['order'] as int? ?? 0,
    );
  }

  static String encodeList(List<TaskModel> tasks) =>
      json.encode(tasks.map((t) => t.toMap()).toList());

  static List<TaskModel> decodeList(String jsonString) {
    final list = json.decode(jsonString) as List<dynamic>;
    return list.map((e) => TaskModel.fromMap(e as Map<String, dynamic>)).toList();
  }

  @override
  List<Object?> get props => [id, title, description, status, dueDate, order];
}
