import 'package:equatable/equatable.dart';
import '../../domain/entities/task.dart';
import '../../core/enums.dart';

class TasksState extends Equatable {
  final List<Task> tasks;
  final TaskStatus? filter;
  final bool loading;
  final String? error;

  const TasksState({
    required this.tasks,
    this.filter,
    this.loading = false,
    this.error,
  });

  factory TasksState.initial() => const TasksState(tasks: [], filter: null, loading: false);

  TasksState copyWith({
    List<Task>? tasks,
    TaskStatus? filter,
    bool? loading,
    String? error,
  }) {
    return TasksState(
      tasks: tasks ?? this.tasks,
      filter: filter ?? this.filter,
      loading: loading ?? this.loading,
      error: error,
    );
  }

  List<Task> get filtered {
    if (filter == null) return tasks;
    return tasks.where((t) => t.status == filter).toList();
  }

  @override
  List<Object?> get props => [tasks, filter, loading, error];
}
