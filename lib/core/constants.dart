import 'package:flutter/material.dart';
import 'package:task_manager/core/enums.dart';

const kStorageKeyTasks = 'TASKS_JSON';
const kMinTitleLength = 3;

const statusColorMap = {
  TaskStatus.todo: Colors.blue,
  TaskStatus.inProgress: Colors.orange,
  TaskStatus.done: Colors.green,
};

