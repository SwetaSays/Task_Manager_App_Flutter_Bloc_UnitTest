import 'package:equatable/equatable.dart';
import '../../domain/entities/task.dart';
import '../../core/enums.dart';

abstract class TasksEvent extends Equatable {
  const TasksEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasksEvent extends TasksEvent {}

class AddTaskEvent extends TasksEvent {
  final Task task;
  const AddTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

class UpdateTaskEvent extends TasksEvent {
  final Task task;
  const UpdateTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

class DeleteTaskEvent extends TasksEvent {
  final String id;
  const DeleteTaskEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class ChangeTaskStatusEvent extends TasksEvent {
  final String id;
  final TaskStatus status;
  const ChangeTaskStatusEvent(this.id, this.status);

  @override
  List<Object?> get props => [id, status];
}

class FilterTasksEvent extends TasksEvent {
  final TaskStatus? filter;
  const FilterTasksEvent(this.filter);

  @override
  List<Object?> get props => [filter];
}

class ReorderTasksEvent extends TasksEvent {
  final List<String> newOrderIds;
  const ReorderTasksEvent(this.newOrderIds);

  @override
  List<Object?> get props => [newOrderIds];
}
