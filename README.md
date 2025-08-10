# Task Manager (Flutter)

A small Task Manager app built with Flutter using BLoC and Clean Architecture.  
Features: task list, add/edit modal, status changes, filter, reorderable list, animated status chips, Material 3 theme, shared_preferences persistence.

## Architecture Overview

Layers:
- presentation — UI, `TasksBloc` (flutter_bloc), pages and widgets.
- domain — Entities (`Task`), use cases (`GetTasks`, `AddTask`, `UpdateTask` etc), repository interface.
- data — Repository implementation and local data source (uses `shared_preferences`) and `TaskModel`.

Repository pattern decouples data access from business logic. Use cases encapsulate operations to keep BLoC logic simple and testable.

## State Management

`flutter_bloc` used. `TasksBloc` handles:
- `LoadTasksEvent`, `AddTaskEvent`, `UpdateTaskEvent`, `ChangeTaskStatusEvent`, `FilterTasksEvent`, `ReorderTasksEvent`.
State: `TasksState` (list of tasks, filter, loading, error).

## UI/UX

- Material 3 theme.
- Responsive padding for tablet widths.
- Reorderable list via `ReorderableListView`.
- Add/Edit uses a modal bottom sheet with validation (title >= 3 chars).
- Status chips are animated and color-coded.
- Swipe actions: quick status changes via Dismissible.

## Persistence

Uses `shared_preferences` to persist tasks as JSON under key `TASKS_JSON`. On first run, app seeds with sample tasks.

## Run
1.  Pull request from git repository
2.  flutter pub get
3.  flutter run

