import 'package:dio/dio.dart';
import 'package:interview/models/user_model.dart';

class ApiService {
  final Dio _dio;
  final String baseUrl = 'https://frontend-interview.touchinspiration.net/api';

  ApiService() : _dio = Dio() {
    _dio.options.baseUrl = baseUrl;
  }

  Future<List<User>> getUsers() async {
    final response = await _dio.get('/users');
    return (response.data as List)
        .map<User>((json) => User.fromJson(json))
        .toList();
  }

  Future<User> updateUser(String id, User user) async {
    final response = await _dio.patch('/user/$id', data: user.toJson());
    return User.fromJson(response.data);
  }

  Future<User> getUser(String id) async {
    final response = await _dio.get('/user/$id');
    return User.fromJson(response.data);
  }

  Future<void> deleteUser(String id) async {
    await _dio.delete('/user/$id');
  }

  Future<User> createUser({
    required String name,
    required String email,
    required String occupation,
    required String bio,
  }) async {
    final response = await _dio.post('/user', data: {
      'name': name,
      'email': email,
      'occupation': occupation,
      'bio': bio,
    });
    return User.fromJson(response.data);
  }
}