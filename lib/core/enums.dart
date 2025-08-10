enum TaskStatus { todo, inProgress, done }

String statusToString(TaskStatus s) {
  switch (s) {
    case TaskStatus.todo:
      return 'To Do';
    case TaskStatus.inProgress:
      return 'In Progress';
    case TaskStatus.done:
      return 'Done';
  }
}
