import '../domain/account_models.dart';

class AccountsRepository {
  // ─────────────────────────────────────────
  // BACKEND INTEGRATION — HDS-02
  // Reemplazar este bloque mock por la llamada real al endpoint:
  // GET /api/v1/accounts
  // Headers requeridos:
  //   Authorization: Bearer {jwt_token}
  //   X-Tenant-ID: {tenant_id}
  //   X-Correlation-ID: {uuid}
  // Response esperado: { accounts: [...] }
  // ─────────────────────────────────────────
  Future<List<Account>> getAccounts(String tenantId) async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      const Account(
        id: 'acc_001',
        number: '001-234567',
        currency: 'COP',
        balance: 5000000,
        isActive: true,
      ),
      const Account(
        id: 'acc_002',
        number: '001-234568',
        currency: 'USD',
        balance: 1200,
        isActive: true,
      ),
      const Account(
        id: 'acc_003',
        number: '001-234569',
        currency: 'COP',
        balance: 0,
        isActive: false,
      ),
    ];
  }
}