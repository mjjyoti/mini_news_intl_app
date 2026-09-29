import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repositories.dart';
import '../datasources/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({required this.localDataSource});

  @override
  Future<({User? user, Failure? failure})> login(String email, String password) async {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      return (user: null, failure: const AuthFailure('Email and password are required'));
    }

    if (email.toLowerCase() != AppConstants.demoEmail || password != AppConstants.demoPassword) {
      return (
      user: null,
      failure: const AuthFailure('Invalid credentials. Use demo@news.com / password123'),
      );
    }

    try {
      await localDataSource.saveLoginState(email);
      return (user: User(email: email, isLoggedIn: true), failure: null);
    } on CacheException catch (e) {
      return (user: null, failure: CacheFailure(e.message));
    } catch (e) {
      return (user: null, failure: UnknownFailure(e.toString()));
    }
  }

  @override
  Future<void> logout() async => localDataSource.clearLoginState();

  @override
  Future<bool> isLoggedIn() => localDataSource.isLoggedIn();

  @override
  Future<String?> getStoredEmail() => localDataSource.getEmail();
}