part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class LoginInitial extends AuthState {}

final class LoginLoading extends AuthState {}

final class LoginSuccess extends AuthState {}

final class LoginFailure extends AuthState {
  final String errMessage;

  LoginFailure({required this.errMessage});
}

final class SignUpInitial extends AuthState {}

final class SignUpLoading extends AuthState {}

final class SignUpSuccess extends AuthState {}

final class SignUpFaliure extends AuthState {
  final String errMessage;

  SignUpFaliure({required this.errMessage});
}
