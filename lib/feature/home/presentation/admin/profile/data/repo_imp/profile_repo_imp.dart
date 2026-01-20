// data/repo_imp/profile_repo_imp.dart
// ignore_for_file: empty_catches

import 'dart:io';
import 'package:mobile_app/core/current_user/data/local_data_soruce/cache_exception.dart';
import 'package:mobile_app/core/current_user/data/local_data_soruce/user_local_data_source.dart';
import 'package:mobile_app/feature/home/data/models/user_model.dart';
import 'package:mobile_app/feature/home/domain/entities/user.dart';
import 'package:mobile_app/feature/home/presentation/admin/profile/domain/repos/profile_repo.dart';

class ProfileRepoImp extends ProfileRepo {
  final UserLocalDataSource localDataSource;

  ProfileRepoImp({required this.localDataSource});

  @override
  Future<User> getCurrentUser() async {
    try {
      final userModel = await localDataSource.getCurrentUser();
      return userModel.toEntity();
    } on CacheException {
      rethrow;
    } catch (e) {
      throw CacheException('Unexpected error while loading user: $e');
    }
  }

  @override
  Future<void> updateProfileImage(File imageFile) async {
    try {
      // Save image locally first
      final imagePath = await localDataSource.saveImageLocally(imageFile);

      // Update user data
      await localDataSource.updateProfileImage(imagePath);

      // await deleteOldProfileImage(oldImagePath);
    } on CacheException {
      rethrow;
    } catch (e) {
      throw CacheException('Unexpected error while updating profile image: $e');
    }
  }

  @override
  Future<void> updateUser(User user) async {
    try {
      final updatedUserModel = UserModel.fromEntity(user);
      await localDataSource.updataUser(updatedUserModel);
    } on CacheException {
      rethrow;
    } catch (e) {
      throw CacheException('Unexpected error while updating user data: $e');
    }
  }

  Future<void> deleteOldProfileImage(String? oldImagePath) async {
    if (oldImagePath != null && oldImagePath.isNotEmpty) {
      try {
        final oldFile = File(oldImagePath);
        if (await oldFile.exists()) {
          await oldFile.delete();
        }
      } catch (e) {}
    }
  }
}
