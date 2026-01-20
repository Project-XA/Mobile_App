import 'package:hive/hive.dart';

part 'auth_state_model.g.dart';

@HiveType(typeId: 3)
class AuthStateModel extends HiveObject {
  @HiveField(0)
  bool hasCompletedOCR;

  @HiveField(1)
  bool hasRegistered;

  @HiveField(2)
  bool isLoggedIn;

  @HiveField(3)
  String? userRole;

  AuthStateModel({
    this.hasCompletedOCR = false,
    this.hasRegistered = false,
    this.isLoggedIn = false,
    this.userRole,
  });

  void reset() {
    hasCompletedOCR = false;
    hasRegistered = false;
    isLoggedIn = false;
    userRole = null;
  }

  void clearAuthOnly() {
    isLoggedIn = false;
    userRole = null;
  }
}
