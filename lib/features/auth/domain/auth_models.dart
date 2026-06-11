import 'package:flutter/foundation.dart';

@immutable
class LoginRequest {
  final String email;
  final String password;
  final String tenantSlug;

  const LoginRequest({
    required this.email,
    required this.password,
    required this.tenantSlug,
  });
}

@immutable
class LoginResponse {
  final String token;
  final String userId;
  final String tenantId;
  final String role;

  const LoginResponse({
    required this.token,
    required this.userId,
    required this.tenantId,
    required this.role,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        token: json['token'] as String,
        userId: json['userId'] as String,
        tenantId: json['tenantId'] as String,
        role: json['role'] as String,
      );
}

@immutable
class AuthUser {
  final String userId;
  final String email;
  final String tenantId;
  final String role;

  const AuthUser({
    required this.userId,
    required this.email,
    required this.tenantId,
    required this.role,
  });
}