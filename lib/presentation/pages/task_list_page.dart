import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/enums.dart';
import '../../presentation/blocs/tasks_bloc.dart';
import '../../presentation/blocs/tasks_event.dart';
import '../../presentation/blocs/tasks_state.dart';
import '../widgets/task_tile.dart';
import 'add_edit_task_page.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.grey[100],
      appBar: AppBar(
        title: const Text('Task Manager'),
        actions: [
          IconButton(
              onPressed: () {
                // refresh
                context.read<TasksBloc>().add(LoadTasksEvent());
              },
              icon: const Icon(Icons.refresh)),
          PopupMenuButton<TaskStatus?>(
            onSelected: (f) {
              context.read<TasksBloc>().add(FilterTasksEvent(f));
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: null, child: Text('All')),
              const PopupMenuItem(value: TaskStatus.todo, child: Text('To Do')),
              const PopupMenuItem(
                  value: TaskStatus.inProgress, child: Text('In Progress')),
              const PopupMenuItem(value: TaskStatus.done, child: Text('Done')),
            ],
          )
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<TasksBloc, TasksState>(
          builder: (context, state) {
            if (state.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            final items = state.filtered;

            if (items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.inbox, size: 72),
                    const SizedBox(height: 12),
                    Text(
                      'No tasks here',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const Text('Try adding a new task using the + button.'),
                  ],
                ),
              );
            }

            // Reorderable list
            return LayoutBuilder(builder: (context, constraints) {
              final isTablet = constraints.maxWidth > 600;
              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 32 : 12, vertical: 8),
                child: ReorderableListView.builder(
                  itemCount: items.length,
                  onReorder: (oldIndex, newIndex) {
                    // adapt for ReorderableListView semantics
                    if (newIndex > oldIndex) newIndex -= 1;
                    final newList = List<String>.from(items.map((t) => t.id));
                    final id = newList.removeAt(oldIndex);
                    newList.insert(newIndex, id);
                    context.read<TasksBloc>().add(ReorderTasksEvent(newList));
                  },
                  buildDefaultDragHandles: false,
                  itemBuilder: (context, index) {
                    final task = items[index];
                    return Dismissible(
                      key: ValueKey(task.id),
                      background: Container(
                        color: Colors.green,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.check, color: Colors.white),
                      ),
                      secondaryBackground: Container(
                        color: Colors.orange,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.update, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        // swipe left -> set InProgress; swipe right -> set Done
                        final newStatus =
                            direction == DismissDirection.startToEnd
                                ? TaskStatus.done
                                : TaskStatus.inProgress;
                        context
                            .read<TasksBloc>()
                            .add(ChangeTaskStatusEvent(task.id, newStatus));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Task marked ${newStatus.name}')),
                        );
                      },
                      child: Card(
                        key: ValueKey('tile_${task.id}'),
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2, 
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          title: TaskTile(task: task),
                          trailing: ReorderableDragStartListener(
                            index: index,
                            child: const Icon(Icons.drag_handle),
                          ),
                          onTap: () {
                            // open edit modal
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16)),
                              ),
                              builder: (context) =>
                                  AddEditTaskPage(existing: task),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            });
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // show add modal
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (context) => const AddEditTaskPage(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
