import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/task.dart';
import '../../core/enums.dart';
import '../../core/constants.dart';
import '../../presentation/blocs/tasks_bloc.dart';
import '../../presentation/blocs/tasks_event.dart';

class AddEditTaskPage extends StatefulWidget {
  final Task? existing;
  const AddEditTaskPage({super.key, this.existing});

  @override
  State<AddEditTaskPage> createState() => _AddEditTaskPageState();
}

class _AddEditTaskPageState extends State<AddEditTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtl = TextEditingController();
  final _descCtl = TextEditingController();
  DateTime _due = DateTime.now().add(const Duration(days: 1));
  TaskStatus _status = TaskStatus.todo;

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      _titleCtl.text = widget.existing!.title;
      _descCtl.text = widget.existing!.description ?? '';
      _due = widget.existing!.dueDate;
      _status = widget.existing!.status;
    }
  }

  @override
  void dispose() {
    _titleCtl.dispose();
    _descCtl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _due,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (selected != null) setState(() => _due = selected);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final id = widget.existing?.id ?? const Uuid().v4();
    final task = Task(
      id: id,
      title: _titleCtl.text.trim(),
      description: _descCtl.text.trim(),
      status: _status,
      dueDate: _due,
      order: widget.existing?.order ?? 0,
    );

    if (widget.existing == null) {
      context.read<TasksBloc>().add(AddTaskEvent(task));
    } else {
      context.read<TasksBloc>().add(UpdateTaskEvent(task));
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Wrap(
          children: [
            ListTile(
              title: Text(widget.existing == null ? 'Add Task' : 'Edit Task'),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            const SizedBox(height: 8),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleCtl,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (v) {
                      if (v == null || v.trim().length < kMinTitleLength) {
                        return 'Title must be at least $kMinTitleLength characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descCtl,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _pickDate,
                          icon: const Icon(Icons.calendar_today),
                          label: Text('Due: ${_due.toLocal().toIso8601String().split('T').first}'),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<TaskStatus>(
                    value: _status,
                    items: TaskStatus.values
                        .map((s) => DropdownMenuItem(value: s, child: Text(s.name)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => _status = v);
                    },
                    decoration: const InputDecoration(labelText: 'Status'),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: _save,
                          child: const Text('Save'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
