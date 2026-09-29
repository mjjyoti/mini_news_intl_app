import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';

abstract class AuthLocalDataSource {
  Future<void> saveLoginState(String email);

  Future<void> clearLoginState();

  Future<bool> isLoggedIn();

  Future<String?> getEmail();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  Box get _box => Hive.box(AppConstants.hiveAuthBox);

  @override
  Future<void> saveLoginState(String email) async {
    try {
      await _box.put(AppConstants.authKey, true);
      await _box.put(AppConstants.userEmailKey, email);
    } catch (e) {
      throw CacheException(message: 'Failed to save login state: $e');
    }
  }

  @override
  Future<void> clearLoginState() async {
    try {
      await _box.delete(AppConstants.authKey);
      await _box.delete(AppConstants.userEmailKey);
    } catch (e) {
      throw CacheException(message: 'Failed to clear login state: $e');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      return _box.get(AppConstants.authKey, defaultValue: false) as bool;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<String?> getEmail() async {
    try {
      return _box.get(AppConstants.userEmailKey) as String?;
    } catch (_) {
      return null;
    }
  }
}
