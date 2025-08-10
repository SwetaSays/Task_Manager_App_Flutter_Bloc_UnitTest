import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager/data/model/task_model.dart';
import 'package:task_manager/core/enums.dart';

void main() {
  test('TaskModel toMap and fromMap roundtrip', () {
    final t = TaskModel(
      id: 'abc123',
      title: 'Test',
      description: 'desc',
      status: TaskStatus.inProgress,
      dueDate: DateTime.parse('2025-01-01'),
      order: 5,
    );

    final map = t.toMap();
    final t2 = TaskModel.fromMap(map);
    expect(t2.id, t.id);
    expect(t2.title, t.title);
    expect(t2.description, t.description);
    expect(t2.status, t.status);
    expect(t2.dueDate, t.dueDate);
    expect(t2.order, t.order);
  });
}
