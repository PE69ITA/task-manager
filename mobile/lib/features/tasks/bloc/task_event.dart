import 'package:equatable/equatable.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasks extends TaskEvent {
  const LoadTasks();
}

class CreateTask extends TaskEvent {
  final String title;
  final String? description;

  const CreateTask({
    required this.title,
    this.description,
  });

  @override
  List<Object?> get props => [title, description];
}

class UpdateTask extends TaskEvent {
  final int id;
  final String? title;
  final String? description;
  final String? status;

  const UpdateTask({
    required this.id,
    this.title,
    this.description,
    this.status,
  });

  @override
  List<Object?> get props => [id, title, description, status];
}

class DeleteTask extends TaskEvent {
  final int id;

  const DeleteTask(this.id);

  @override
  List<Object?> get props => [id];
}