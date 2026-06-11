import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../domain/auth_models.dart';
import '../../../core/constants/app_constants.dart';

class AuthRepository {
  final _storage = const FlutterSecureStorage();

  // ─────────────────────────────────────────
  // BACKEND INTEGRATION — HDS-01
  // Reemplazar este bloque mock por la llamada real al endpoint:
  // POST /api/v1/auth/login
  // Headers requeridos:
  //   X-Tenant-ID: {tenant_slug}
  //   Idempotency-Key: {uuid}
  // Request body: { email, password }
  // Response esperado: { token, userId, tenantId, role }
  // ─────────────────────────────────────────
  Future<LoginResponse> login(LoginRequest request) async {
    await Future.delayed(const Duration(seconds: 1));

    final mockUsers = {
      'admin@bancolombia.com': {
        'password': 'Admin123!',
        'userId': 'usr_001',
        'tenantId': 'ten_bancolombia',
        'role': 'admin',
      },
      'cliente@bancolombia.com': {
        'password': 'Cliente123!',
        'userId': 'usr_002',
        'tenantId': 'ten_bancolombia',
        'role': 'client',
      },
    };

    final user = mockUsers[request.email];

    if (user == null || user['password'] != request.password) {
      throw Exception('Credenciales inválidas');
    }

    final response = LoginResponse(
      token: 'mock_jwt_token_${user['userId']}',
      userId: user['userId']!,
      tenantId: user['tenantId']!,
      role: user['role']!,
    );

    await _storage.write(key: AppConstants.keyJwt, value: response.token);
    await _storage.write(key: AppConstants.keyUserId, value: response.userId);
    await _storage.write(
        key: AppConstants.keyTenantId, value: response.tenantId);

    return response;
  }

  Future<void> logout() async {
    await _storage.deleteAll();
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: AppConstants.keyJwt);
    return token != null;
  }

  Future<String?> getToken() async {
    return _storage.read(key: AppConstants.keyJwt);
  }

  Future<String?> getTenantId() async {
    return _storage.read(key: AppConstants.keyTenantId);
  }
}