import '../repositories/task_repository.dart';

class ChangeStatus {
  final TaskRepository repository;
  ChangeStatus(this.repository);

  Future<void> call(String id, int statusIndex) async {
    return repository.changeStatus(id, statusIndex);
  }
}
