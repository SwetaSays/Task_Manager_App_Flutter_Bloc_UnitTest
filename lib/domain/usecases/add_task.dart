import '../entities/task.dart';
import '../repositories/task_repository.dart';

class AddTask {
  final TaskRepository repository;
  AddTask(this.repository);

  Future<void> call(Task task) async {
    return repository.addTask(task);
  }
}
