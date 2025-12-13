import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_app/core/Data/local_data_soruce/cache_exception.dart';
import 'package:mobile_app/feature/home/data/models/user_model.dart';
import 'package:path_provider/path_provider.dart';

abstract class UserLocalDataSource {
  Future<UserModel> getCurrentUser();
  Future<void> saveLocalUserData(UserModel user);
  Future<void> saveUserLogin(UserModel user);
  Future<void> updataUser(UserModel user);
  Future<void> updateProfileImage(String imagePath);
  Future<String> saveImageLocally(File imageFile);
}

class UserLocalDataSourceImp extends UserLocalDataSource {
  final Box<UserModel> userBox;
  static const String _currentUserKey = 'current_user';

  UserLocalDataSourceImp({required this.userBox});
  @override
  Future<UserModel> getCurrentUser() async {
    final user = userBox.get(_currentUserKey);
    if (user == null) {
      throw CacheException("No user fpund in local storage");
    }
    return user;
  }

  @override
  Future<String> saveImageLocally(File imageFile) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final localPath = '${appDir.path}/profile_images';

      final directory = Directory(localPath);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.png';
      final savedImage = await imageFile.copy('$localPath/$fileName');

      return savedImage.path;
    } catch (e) {
      throw CacheException('Failed to save image locally: $e');
    }
  }

  @override
  Future<void> saveLocalUserData(UserModel user) async {
    try {
      await userBox.put(_currentUserKey, user);
    } catch (e) {
      throw CacheException("Failed to save local $e");
    }
  }

  @override
  Future<void> saveUserLogin(UserModel user) async {
    try {
      await userBox.put(_currentUserKey, user);
    } catch (e) {
      throw CacheException('Failed to save user: $e');
    }
  }

  @override
  Future<void> updataUser(UserModel user) async {
    try {
      await userBox.put(_currentUserKey, user);
    } catch (e) {
      throw CacheException('Failed to update user: $e');
    }
  }

  @override
  Future<void> updateProfileImage(String imagePath) async {
    try {
      final user = await getCurrentUser();
      user.profileImage = imagePath;
      await user.save();
    } catch (e) {
      throw CacheException('Failed to update profile image: $e');
    }
  }
}
