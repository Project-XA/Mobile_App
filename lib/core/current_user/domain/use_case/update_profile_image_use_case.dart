import 'dart:io';

import 'package:mobile_app/core/current_user/domain/repo/current_user_repo.dart';

class UpdateProfileImageUseCase {
  final CurrentUserRepository _repository;
  UpdateProfileImageUseCase(this._repository);
  Future<void> call(File imageFile) async {
    return await _repository.updateProfileImage(imageFile);
  }
}
