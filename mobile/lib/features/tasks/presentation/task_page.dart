import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import '../models/task.dart';
import 'widgets/task_card.dart';
import 'widgets/task_form_dialog.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  String selectedFilter = 'ALL';

  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(const LoadTasks());
  }

  Future<void> _showTaskDialog({Task? task}) async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => TaskFormDialog(task: task),
    );

    if (!mounted || result == null) return;

    if (task == null) {
      context.read<TaskBloc>().add(
            CreateTask(
              title: result['title']!,
              description: result['description'],
            ),
          );
    } else {
      context.read<TaskBloc>().add(
            UpdateTask(
              id: task.id,
              title: result['title'],
              description: result['description'],
            ),
          );
    }
  }

  Future<void> _deleteTask(Task task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (!mounted || confirmed != true) return;

    context.read<TaskBloc>().add(DeleteTask(task.id));
  }

  void _updateTaskStatus(Task task, String status) {
    context.read<TaskBloc>().add(
          UpdateTask(
            id: task.id,
            status: status,
          ),
        );
  }

  List<Task> _filterTasks(List<Task> tasks) {
    if (selectedFilter == 'ALL') {
      return tasks;
    }

    return tasks
        .where((task) => task.status == selectedFilter)
        .toList();
  }

  Widget _buildFilter(List<Task> tasks) {
    final filters = [
      {'value': 'ALL', 'label': 'All'},
      {'value': 'TODO', 'label': 'To Do'},
      {'value': 'IN_PROGRESS', 'label': 'In Progress'},
      {'value': 'DONE', 'label': 'Done'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: filters.map((filter) {
          final isSelected = selectedFilter == filter['value'];

          final count = filter['value'] == 'ALL'
              ? tasks.length
              : tasks
                  .where((task) => task.status == filter['value'])
                  .length;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text('${filter['label']} ($count)'),
              selected: isSelected,
              onSelected: (_) {
                setState(() {
                  selectedFilter = filter['value']!;
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          IconButton(
            onPressed: () {
              context.read<TaskBloc>().add(const LoadTasks());
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is TaskError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.message),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TaskBloc>().add(const LoadTasks());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is TaskLoaded) {
            final filteredTasks = _filterTasks(state.tasks);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.isProcessing)
                  const LinearProgressIndicator(),

                if (state.operationError != null)
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      state.operationError!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),

                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Text(
                    'Stay organized and productive.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF888894),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                _buildFilter(state.tasks),

                const SizedBox(height: 12),

                Expanded(
                  child: filteredTasks.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.task_alt,
                                size: 56,
                                color: Color(0xFFB9B9C8),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                selectedFilter == 'ALL'
                                    ? 'No tasks yet'
                                    : 'No tasks with this status',
                                style: const TextStyle(
                                  color: Color(0xFF888894),
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            context.read<TaskBloc>().add(
                                  const LoadTasks(),
                                );
                          },
                          child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: 90),
                            itemCount: filteredTasks.length,
                            itemBuilder: (context, index) {
                              final task = filteredTasks[index];

                              return TaskCard(
                                task: task,
                                onEdit: () {
                                  _showTaskDialog(task: task);
                                },
                                onDelete: () {
                                  _deleteTask(task);
                                },
                                onStatusChanged: (status) {
                                  _updateTaskStatus(task, status);
                                },
                              );
                            },
                          ),
                        ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showTaskDialog(),
        icon: const Icon(Icons.add),
        label: const Text('New Task'),
        backgroundColor: const Color(0xFF5856D6),
        foregroundColor: Colors.white,
      ),
    );
  }
}