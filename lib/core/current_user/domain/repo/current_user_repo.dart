import 'dart:io';

import 'package:mobile_app/feature/home/domain/entities/user.dart';

abstract class CurrentUserRepository {
  Future<User> getCurrentUser();
  Future<void> updateProfileImage(File imageFile);
  Future<void> updateUser(User user);
}
