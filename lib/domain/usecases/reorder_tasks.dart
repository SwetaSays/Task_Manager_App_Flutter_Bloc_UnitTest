import '../repositories/task_repository.dart';

class ReorderTasks {
  final TaskRepository repository;
  ReorderTasks(this.repository);

  Future<void> call(List<String> idsInNewOrder) async {
    return repository.reorder(idsInNewOrder);
  }
}
