import '../domain/operation_models.dart';
import '../../../core/constants/app_constants.dart';

class OperationsRepository {
  // ─────────────────────────────────────────
  // BACKEND INTEGRATION — HDS-04
  // Reemplazar este bloque mock por la llamada real al endpoint:
  // POST /api/v1/operations/deposit
  // Headers requeridos:
  //   Authorization: Bearer {jwt_token}
  //   X-Tenant-ID: {tenant_id}
  //   Idempotency-Key: {uuid}
  //   X-Correlation-ID: {uuid}
  // Request body: { accountId, amount, currency }
  // Response esperado: { transactionId, success, finalAmount }
  // ─────────────────────────────────────────
  Future<OperationResult> deposit(DepositRequest request) async {
    await Future.delayed(const Duration(seconds: 1));

    return OperationResult(
      transactionId: 'txn_${DateTime.now().millisecondsSinceEpoch}',
      success: true,
      finalAmount: request.amount,
    );
  }

  // ─────────────────────────────────────────
  // BACKEND INTEGRATION — HDS-05
  // Reemplazar este bloque mock por la llamada real al endpoint:
  // POST /api/v1/operations/withdrawal
  // Headers requeridos:
  //   Authorization: Bearer {jwt_token}
  //   X-Tenant-ID: {tenant_id}
  //   Idempotency-Key: {uuid}
  //   X-Correlation-ID: {uuid}
  // Request body: { accountId, amount, currency, pin }
  // Response esperado: { transactionId, success, finalAmount }
  // ─────────────────────────────────────────
  Future<OperationResult> withdrawal(WithdrawalRequest request) async {
    await Future.delayed(const Duration(seconds: 1));

    if (request.pin != '1234') {
      return const OperationResult(
        transactionId: '',
        success: false,
        errorMessage: 'PIN incorrecto',
      );
    }

    return OperationResult(
      transactionId: 'txn_${DateTime.now().millisecondsSinceEpoch}',
      success: true,
      finalAmount: request.amount,
    );
  }

  // ─────────────────────────────────────────
  // BACKEND INTEGRATION — HDS-06
  // Reemplazar este bloque mock por la llamada real al endpoint:
  // POST /api/v1/operations/transfer
  // Headers requeridos:
  //   Authorization: Bearer {jwt_token}
  //   X-Tenant-ID: {tenant_id}
  //   Idempotency-Key: {uuid}
  //   X-Correlation-ID: {uuid}
  // Request body: { sourceAccountId, destinationAccountId, amount, currency, pin }
  // Response esperado: { transactionId, success, fee, finalAmount }
  // ─────────────────────────────────────────
  Future<OperationResult> transfer(TransferRequest request) async {
    await Future.delayed(const Duration(seconds: 1));

    if (request.pin != '1234') {
      return const OperationResult(
        transactionId: '',
        success: false,
        errorMessage: 'PIN incorrecto',
      );
    }

    final fee = request.amount * AppConstants.transferFeePercent;
    final finalAmount = request.amount + fee;

    return OperationResult(
      transactionId: 'txn_${DateTime.now().millisecondsSinceEpoch}',
      success: true,
      fee: fee,
      finalAmount: finalAmount,
    );
  }
}