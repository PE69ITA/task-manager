import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/task_repository.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository repository;

  TaskBloc(this.repository) : super(const TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<CreateTask>(_onCreateTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
  }

  Future<void> _onLoadTasks(
    LoadTasks event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskLoading());

    try {
      final tasks = await repository.getTasks();
      emit(TaskLoaded(tasks));
    } catch (error) {
      emit(TaskError('Failed to load tasks: $error'));
    }
  }

  Future<void> _performOperation(
    Emitter<TaskState> emit,
    Future<void> Function() operation,
    String errorMessage,
  ) async {
    final currentTasks = state is TaskLoaded
        ? (state as TaskLoaded).tasks
        : <dynamic>[];

    emit(TaskLoaded(
      currentTasks.cast(),
      isProcessing: true,
    ));

    try {
      await operation();

      final tasks = await repository.getTasks();

      emit(TaskLoaded(tasks));
    } catch (error) {
      emit(TaskLoaded(
        currentTasks.cast(),
        operationError: '$errorMessage: $error',
      ));
    }
  }

  Future<void> _onCreateTask(
    CreateTask event,
    Emitter<TaskState> emit,
  ) async {
    await _performOperation(
      emit,
      () async {
        await repository.createTask(
          title: event.title,
          description: event.description,
        );
      },
      'Failed to create task',
    );
  }

  Future<void> _onUpdateTask(
    UpdateTask event,
    Emitter<TaskState> emit,
  ) async {
    await _performOperation(
      emit,
      () async {
        await repository.updateTask(
          event.id,
          title: event.title,
          description: event.description,
          status: event.status,
        );
      },
      'Failed to update task',
    );
  }

  Future<void> _onDeleteTask(
    DeleteTask event,
    Emitter<TaskState> emit,
  ) async {
    await _performOperation(
      emit,
      () async {
        await repository.deleteTask(event.id);
      },
      'Failed to delete task',
    );
  }
}