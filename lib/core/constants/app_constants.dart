abstract final class AppConstants {
  // ── API ────────────────────────────────────
  static const baseUrl = 'https://api.bankos.com/api/v1';
  static const timeout = Duration(seconds: 30);

  // ── Tenants mock ───────────────────────────
  static const tenantA = 'bancolombia-demo';
  static const tenantB = 'nequi-demo';

  // ── Storage keys ───────────────────────────
  static const keyJwt = 'jwt_token';
  static const keyTenantId = 'tenant_id';
  static const keyUserId = 'user_id';

  // ── Tasas mock ─────────────────────────────
  static const usdToCop = 4200.0;
  static const copToUsd = 0.000238;

  // ── Comisión mock ──────────────────────────
  static const transferFeePercent = 0.015;
}