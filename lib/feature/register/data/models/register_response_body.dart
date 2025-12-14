class RegisterResponseBody {
  final String role;

  RegisterResponseBody({required this.role});

  factory RegisterResponseBody.fromResponse(dynamic response) {
    if (response is String) {
      return RegisterResponseBody(role: response.trim());
    } else if (response is Map<String, dynamic>) {
      return RegisterResponseBody(role: response['role']);
    } else {
      throw Exception('Invalid response format');
    }
  }

  factory RegisterResponseBody.fromJson(Map<String, dynamic> json) {
    return RegisterResponseBody(role: json['role']);
  }

  Map<String, dynamic> toJson() {
    return {"role": role};
  }
}