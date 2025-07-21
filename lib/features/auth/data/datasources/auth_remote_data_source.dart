import 'package:dio/dio.dart';
import 'package:nodelabs_case/core/network/api_client.dart';
import 'package:nodelabs_case/features/auth/data/models/register_request.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';

class AuthRemoteDataSource {
  final Dio _dio = ApiClient().dio;

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post('/user/login', data: request.toJson());
      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Login failed');
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<LoginResponse> register(RegisterRequest request) async {
    try {
      final response = await _dio.post(
        '/user/register',
        data: request.toJson(),
      );
      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Register failed');
    } catch (e) {
      throw Exception('Register failed: $e');
    }
  }
}
