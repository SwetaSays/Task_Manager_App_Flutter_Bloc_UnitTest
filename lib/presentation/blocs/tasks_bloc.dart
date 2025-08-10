// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'tasks_event.dart';
import 'tasks_state.dart';
import '../../domain/usecases/get_tasks.dart';
import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/update_task.dart';
import '../../domain/usecases/change_status.dart';
import '../../domain/usecases/reorder_tasks.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final GetTasks getTasksUsecase;
  final AddTask addTaskUsecase;
  final UpdateTask updateTaskUsecase;
  final ChangeStatus changeStatusUsecase;
  final ReorderTasks reorderTasksUsecase;

  TasksBloc({
    required this.getTasksUsecase,
    required this.addTaskUsecase,
    required this.updateTaskUsecase,
    required this.changeStatusUsecase,
    required this.reorderTasksUsecase,
  }) : super(TasksState.initial()) {
    on<LoadTasksEvent>(_onLoad);
    on<AddTaskEvent>(_onAdd);
    on<UpdateTaskEvent>(_onUpdate);
    on<DeleteTaskEvent>(_onDelete);
    on<ChangeTaskStatusEvent>(_onChangeStatus);
    on<FilterTasksEvent>(_onFilter);
    on<ReorderTasksEvent>(_onReorder);
  }

  Future<void> _onLoad(LoadTasksEvent event, Emitter<TasksState> emit) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final tasks = await getTasksUsecase();
      emit(state.copyWith(tasks: tasks, loading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), loading: false));
    }
  }

  Future<void> _onAdd(AddTaskEvent event, Emitter<TasksState> emit) async {
    emit(state.copyWith(loading: true));
    try {
      await addTaskUsecase(event.task);
      final tasks = await getTasksUsecase();
      emit(state.copyWith(tasks: tasks, loading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), loading: false));
    }
  }

  Future<void> _onUpdate(UpdateTaskEvent event, Emitter<TasksState> emit) async {
    emit(state.copyWith(loading: true));
    try {
      await updateTaskUsecase(event.task);
      final tasks = await getTasksUsecase();
      emit(state.copyWith(tasks: tasks, loading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), loading: false));
    }
  }

  Future<void> _onDelete(DeleteTaskEvent event, Emitter<TasksState> emit) async {
    emit(state.copyWith(loading: true));
    try {
      await getTasksUsecase(); 
      emit(state.copyWith(loading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), loading: false));
    }
  }

  Future<void> _onChangeStatus(ChangeTaskStatusEvent event, Emitter<TasksState> emit) async {
    emit(state.copyWith(loading: true));
    try {
      await changeStatusUsecase(event.id, event.status.index);
      final tasks = await getTasksUsecase();
      emit(state.copyWith(tasks: tasks, loading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), loading: false));
    }
  }

  Future<void> _onFilter(FilterTasksEvent event, Emitter<TasksState> emit) async {
    emit(state.copyWith(filter: event.filter));
  }

  Future<void> _onReorder(ReorderTasksEvent event, Emitter<TasksState> emit) async {
    emit(state.copyWith(loading: true));
    try {
      await reorderTasksUsecase(event.newOrderIds);
      final tasks = await getTasksUsecase();
      emit(state.copyWith(tasks: tasks, loading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), loading: false));
    }
  }
}
