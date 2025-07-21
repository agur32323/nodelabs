import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nodelabs_case/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:nodelabs_case/features/auth/data/models/login_request.dart';
import 'package:nodelabs_case/features/auth/data/models/login_response.dart';
import 'package:nodelabs_case/features/auth/data/models/register_request.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRemoteDataSource dataSource;
  final _secureStorage = const FlutterSecureStorage();

  AuthBloc(this.dataSource) : super(AuthInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(AuthLoading());
      try {
        final response = await dataSource.login(
          LoginRequest(email: event.email, password: event.password),
        );

        final token = response.token;
        if (token != null && token.isNotEmpty) {
          await _secureStorage.write(key: 'token', value: token);
        } else {}

        emit(AuthSuccess(response));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<RegisterSubmitted>((event, emit) async {
      emit(AuthLoading());
      try {
        final response = await dataSource.register(
          RegisterRequest(
            name: event.name,
            email: event.email,
            password: event.password,
          ),
        );

        if (response.token != null && response.token!.isNotEmpty) {
          await _secureStorage.write(key: 'token', value: response.token!);
        }

        emit(AuthSuccess(response));
      } catch (e) {
        if (e is DioException) {
          emit(
            AuthFailure(
              e.response?.data.toString() ?? e.message ?? 'Unknown error',
            ),
          );
        } else {
          emit(AuthFailure(e.toString()));
        }
      }
    });
  }
}
