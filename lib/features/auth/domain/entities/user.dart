import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String email;
  final bool isLoggedIn;

  const User({required this.email, required this.isLoggedIn});

  @override
  List<Object?> get props => [email, isLoggedIn];
}
