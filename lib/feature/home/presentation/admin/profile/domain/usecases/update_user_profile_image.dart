import 'dart:io';
import 'package:mobile_app/core/current_user/data/local_data_soruce/cache_exception.dart';
import 'package:mobile_app/feature/home/presentation/admin/profile/domain/repos/profile_repo.dart';

class UpdateUserProfileImage {
  final ProfileRepo repo;
  
  UpdateUserProfileImage(this.repo);
  
  Future<void> updateprofileImage(File imageFile) async {
    try {
      if (!await imageFile.exists()) {
        throw Exception('image not found');
      }
      
      final fileSize = await imageFile.length();
      if (fileSize > 5 * 1024 * 1024) {
        throw Exception('image size is large');
      }
      
      await repo.updateProfileImage(imageFile);
    } on CacheException catch (e) {
      throw CacheException('field ${e.message}');
    } catch (e) {
      throw Exception('error occur $e');
    }
  }
}