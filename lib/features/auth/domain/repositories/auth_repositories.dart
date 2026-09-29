import '../entities/user.dart';
import '../../../../core/errors/failures.dart';

abstract class AuthRepository {
  Future<({User? user, Failure? failure})> login(String email, String password);
  Future<void> logout();
  Future<bool> isLoggedIn();
  Future<String?> getStoredEmail();
}