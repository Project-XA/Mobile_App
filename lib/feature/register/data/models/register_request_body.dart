class RegisterRequestBody {
  final String organizationCode; 
  final String email;
  final String password;

  RegisterRequestBody({
    required this.organizationCode,
    required this.email,
    required this.password,
  });

  factory RegisterRequestBody.fromJson(Map<String, dynamic> json) {
    return RegisterRequestBody(
      organizationCode: json["organization_code"], 
      email: json["email"],
      password: json["password"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "organization_code": organizationCode,
      "email": email,
      "password": password,
    };
  }
}