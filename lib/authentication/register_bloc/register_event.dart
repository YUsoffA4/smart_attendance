import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterEmailChanged extends RegisterEvent {
  final String email;

  const RegisterEmailChanged({@required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'RegisterEmailChanged { email :$email }';
}

class RegisterNameChanged extends RegisterEvent {
  final String name;

  const RegisterNameChanged({@required this.name});

  @override
  List<Object> get props => [name];

  @override
  String toString() => 'RegisterNameChanged { name :$name }';
}

class RegisterCodeChanged extends RegisterEvent {
  final String code;

  const RegisterCodeChanged({@required this.code});

  @override
  List<Object> get props => [code];

  @override
  String toString() => 'RegisterCodeChanged { code :$code }';
}

class RegisterPasswordChanged extends RegisterEvent {
  final String password;

  const RegisterPasswordChanged({@required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'RegisterPasswordChanged { password: $password }';
}

class RegisterSubmitted extends RegisterEvent {
  final String orgId;
  final String email;
  final String password;
  final String name;
  final String code;
  final bool isAdmin;

  const RegisterSubmitted({
    @required this.orgId,
    @required this.email,
    @required this.password,
    @required this.name,
    @required this.code,
    @required this.isAdmin,
  });

  @override
  List<Object> get props => [email, password, name, code, isAdmin, orgId];

  @override
  String toString() {
    return 'RegisterSubmitted { email: $email, password: $password name $name code $code isAdmin $isAdmin orgId $orgId}';
  }
}
