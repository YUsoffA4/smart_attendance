part of 'authentication_bloc.dart';


abstract class AuthenticationState extends Equatable{
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {
  final String userId;
  const AuthenticationSuccess(this.userId);

  @override
  List<Object> get props => [userId];

  @override
  String toString() => 'AuthenticationSuccess { displayName: $userId }';
}

class AuthenticationFailure extends AuthenticationState {}
