import '../entities/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks();
  Future<void> addTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String id);
  Future<void> changeStatus(String id, int statusIndex);
  Future<void> reorder(List<String> idsInNewOrder);
}
