import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../models/task.dart';

class TaskRepository {
  final Dio _dio;

  TaskRepository(ApiClient apiClient) : _dio = apiClient.dio;

  Future<List<Task>> getTasks() async {
    final response = await _dio.get('/tasks');

    return (response.data as List)
        .map((json) => Task.fromJson(json))
        .toList();
  }

  Future<Task> getTaskById(int id) async {
    final response = await _dio.get('/tasks/$id');

    return Task.fromJson(response.data);
  }

  Future<Task> createTask({
    required String title,
    String? description,
  }) async {
    final response = await _dio.post(
      '/tasks',
      data: {
        'title': title,
        'description': description,
      },
    );

    return Task.fromJson(response.data);
  }

  Future<Task> updateTask(
    int id, {
    String? title,
    String? description,
    String? status,
  }) async {
    final data = <String, dynamic>{};

    if (title != null) data['title'] = title;
    if (description != null) data['description'] = description;
    if (status != null) data['status'] = status;

    final response = await _dio.put(
      '/tasks/$id',
      data: data,
    );

    return Task.fromJson(response.data);
  }

  Future<void> deleteTask(int id) async {
    await _dio.delete('/tasks/$id');
  }
}