import 'package:equatable/equatable.dart';

import '../models/task.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {
  const TaskInitial();
}

class TaskLoading extends TaskState {
  const TaskLoading();
}

class TaskLoaded extends TaskState {
  final List<Task> tasks;
  final bool isProcessing;
  final String? operationError;

  const TaskLoaded(
    this.tasks, {
    this.isProcessing = false,
    this.operationError,
  });

  TaskLoaded copyWith({
    List<Task>? tasks,
    bool? isProcessing,
    String? operationError,
    bool clearOperationError = false,
  }) {
    return TaskLoaded(
      tasks ?? this.tasks,
      isProcessing: isProcessing ?? this.isProcessing,
      operationError: clearOperationError
          ? null
          : operationError ?? this.operationError,
    );
  }

  @override
  List<Object?> get props => [
        tasks,
        isProcessing,
        operationError,
      ];
}

class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object?> get props => [message];
}