import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/presentation/blocs/tasks_event.dart';

import 'domain/usecases/add_task.dart';
import 'domain/usecases/change_status.dart';
import 'domain/usecases/get_tasks.dart';
import 'domain/usecases/reorder_tasks.dart';
import 'domain/usecases/update_task.dart';
import 'presentation/blocs/tasks_bloc.dart';
import 'presentation/pages/task_list_page.dart';

class TaskManagerApp extends StatelessWidget {
  final GetTasks getTasks;
  final AddTask addTask;
  final UpdateTask updateTask;
  final ChangeStatus changeStatus;
  final ReorderTasks reorderTasks;

  const TaskManagerApp({
    super.key,
    required this.getTasks,
    required this.addTask,
    required this.updateTask,
    required this.changeStatus,
    required this.reorderTasks,
  });

  @override
  Widget build(BuildContext context) {
    // default locale for intl formatting
    Intl.defaultLocale = 'en_US';

    return MultiBlocProvider(
      providers: [
        BlocProvider<TasksBloc>(
          create: (_) => TasksBloc(
            getTasksUsecase: getTasks,
            addTaskUsecase: addTask,
            updateTaskUsecase: updateTask,
            changeStatusUsecase: changeStatus,
            reorderTasksUsecase: reorderTasks,
          )..add(LoadTasksEvent()),
        ),
      ],
      child: MaterialApp(
        title: 'Task Manager',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.indigo,
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.indigo,
          brightness: Brightness.dark,
        ),
        themeMode: ThemeMode.system,
        home: const TaskListPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
