// domain/entities/user.dart
import 'package:mobile_app/core/curren_user/domain/entities/user_org.dart';

class User {
  final String? id;
  final String nationalId;
  final String firstNameAr;
  final String lastNameAr;
  final String? address;
  final String? birthDate;
  final String? idCardImage;

  final String? email;
  final String? firstNameEn;
  final String? lastNameEn;
  final List<UserOrg>? organizations;

  final String? profileImage;

  final String? loginToken;
  final String? username;

  User({
    required this.nationalId,
    required this.firstNameAr,
    required this.lastNameAr,
    this.address,
    this.username,
    this.id,
    this.birthDate,
    this.email,
    this.firstNameEn,
    this.lastNameEn,
    this.organizations,
    this.profileImage,
    this.idCardImage,
    this.loginToken,
  });

  User copyWith({
    String? nationalId,
    String? firstNameAr,
    String? lastNameAr,
    String? address,
    String? birthDate,
    String? email,
    String? firstNameEn,
    String? lastNameEn,
    List<UserOrg>? organizations,
    String? profileImage,
    String? idCardImage,
    String? id,
    String? loginToken,
    String? username,
  }) {
    return User(
      id: id ?? this.id,
      nationalId: nationalId ?? this.nationalId,
      firstNameAr: firstNameAr ?? this.firstNameAr,
      lastNameAr: lastNameAr ?? this.lastNameAr,
      address: address ?? this.address,
      birthDate: birthDate ?? this.birthDate,
      email: email ?? this.email,
      firstNameEn: firstNameEn ?? this.firstNameEn,
      lastNameEn: lastNameEn ?? this.lastNameEn,
      organizations: organizations ?? this.organizations,
      profileImage: profileImage ?? this.profileImage,
      idCardImage: idCardImage ?? this.idCardImage,
      loginToken: loginToken ?? this.loginToken,
      username: username ?? this.username,
    );
  }

  // Getters
  String get fullNameAr => '$firstNameAr $lastNameAr';

  String get fullNameEn => firstNameEn != null && lastNameEn != null
      ? '$firstNameEn $lastNameEn'
      : fullNameAr;

  bool get isRegistered => email != null && organizations != null;

  // ⭐ Check if user is logged in (has valid token)
  bool get isLoggedIn => loginToken != null && loginToken!.isNotEmpty;
}
