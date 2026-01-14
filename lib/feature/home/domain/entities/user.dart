// domain/entities/user.dart
import 'package:mobile_app/feature/home/domain/entities/user_org.dart';

class User {
  // ========== Local Data (من البطاقة) ==========
  final String nationalId;      
  final String firstNameAr;        
  final String lastNameAr;          
  final String? address;            
  final String? birthDate;           
  
  // ========== Remote Data (من الـ API) ==========
  final String? email;          
  final String? firstNameEn;        
  final String? lastNameEn;       
  final List<UserOrg>? organizations;
  
  // ========== Profile Data ==========
  final String? profileImage;      
  
  User({
    required this.nationalId,
    required this.firstNameAr,
    required this.lastNameAr,
    this.address,
    this.birthDate,
    this.email,
    this.firstNameEn,
    this.lastNameEn,
    this.organizations,
    this.profileImage,
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
  }) {
    return User(
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
    );
  }
  
  // Getters
  String get fullNameAr => '$firstNameAr $lastNameAr';
  String get fullNameEn => firstNameEn != null && lastNameEn != null
      ? '$firstNameEn $lastNameEn'
      : fullNameAr;
  
  bool get isRegistered => email != null && organizations != null;
}