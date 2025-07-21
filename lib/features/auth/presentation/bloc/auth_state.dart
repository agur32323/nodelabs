part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final LoginResponse response;

  AuthSuccess(this.response);
}

class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);
}
