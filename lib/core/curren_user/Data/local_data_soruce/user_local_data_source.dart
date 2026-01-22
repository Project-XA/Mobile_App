import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_app/core/curren_user/Data/local_data_soruce/cache_exception.dart';
import 'package:mobile_app/core/curren_user/Data/models/user_model.dart';
import 'package:path_provider/path_provider.dart';

abstract class UserLocalDataSource {
  Future<UserModel> getCurrentUser();
  Future<void> saveLocalUserData(UserModel user);
  Future<void> saveUserLogin(UserModel user);
  Future<void> updataUser(UserModel user);
  Future<void> updateProfileImage(String imagePath);
  Future<String> saveImageLocally(File imageFile);
  Future<void> deleteOldProfileImage(String imagePath);
  Future<bool> hasCurrentUser();
  Future<String> getIdCardImagePath();
  Future<void> logout();
  Future<bool> hasValidToken();
}

class UserLocalDataSourceImp extends UserLocalDataSource {
  final Box<UserModel> userBox;
  static const String _currentUserKey = 'current_user';

  UserLocalDataSourceImp({required this.userBox});

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final user = userBox.get(_currentUserKey);
      if (user == null) {
        throw CacheException('No user found in local storage');
      }
      return user;
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException('Failed to read user data: $e');
    }
  }

  @override
  Future<String> getIdCardImagePath() async {
    try {
      final user = await getCurrentUser();
      final idCardImagePath = user.idCardImage;
      if (idCardImagePath == null || idCardImagePath.isEmpty) {
        throw CacheException('ID card image path not found');
      }
      return idCardImagePath;
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException('Failed to get ID card image path: $e');
    }
  }

  @override
  Future<bool> hasCurrentUser() async {
    try {
      return userBox.containsKey(_currentUserKey);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> hasValidToken() async {
    try {
      final user = userBox.get(_currentUserKey);
      return user != null && 
             user.loginToken != null && 
             user.loginToken!.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<String> saveImageLocally(File imageFile) async {
    try {
      if (!await imageFile.exists()) {
        throw CacheException('Selected file does not exist');
      }

      final appDir = await getApplicationDocumentsDirectory();
      final localPath = '${appDir.path}/profile_images';
      final directory = Directory(localPath);

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'profile_$timestamp.png';
      final targetPath = '$localPath/$fileName';

      final savedImage = await imageFile.copy(targetPath);

      if (!await savedImage.exists()) {
        throw CacheException('Failed to save image');
      }

      return savedImage.path;
    } on CacheException {
      rethrow;
    } catch (e) {
      throw CacheException('Failed to save image locally: $e');
    }
  }

  @override
  Future<void> deleteOldProfileImage(String imagePath) async {
    try {
      if (imagePath.isEmpty) return;

      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      throw CacheException('Failed to delete old profile image: $e');
    }
  }

  @override
  Future<void> saveLocalUserData(UserModel user) async {
    try {
      await userBox.put(_currentUserKey, user);
      await userBox.flush();
    } catch (e) {
      throw CacheException('Failed to save user data: $e');
    }
  }

  @override
  Future<void> saveUserLogin(UserModel user) async {
    try {
      await userBox.put(_currentUserKey, user);
      await userBox.flush();
    } catch (e) {
      throw CacheException('Failed to save login data: $e');
    }
  }

  @override
  Future<void> updataUser(UserModel user) async {
    try {
      await userBox.put(_currentUserKey, user);
      await userBox.flush();
    } catch (e) {
      throw CacheException('Failed to update user data: $e');
    }
  }

  @override
  Future<void> updateProfileImage(String imagePath) async {
    try {
      final user = await getCurrentUser();
      final oldImagePath = user.profileImage;

      user.profileImage = imagePath;

      await userBox.put(_currentUserKey, user);
      await userBox.flush();

      if (oldImagePath != null && oldImagePath.isNotEmpty) {
        await deleteOldProfileImage(oldImagePath);
      }
    } catch (e) {
      throw CacheException('Failed to update profile image: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      final user = await getCurrentUser();
      
      user.loginToken = null;
      
      await userBox.put(_currentUserKey, user);
      await userBox.flush();
    } catch (e) {
      throw CacheException('Failed to logout: $e');
    }
  }
}