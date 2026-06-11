import '../domain/transaction_models.dart';

class TransactionsRepository {
  // ─────────────────────────────────────────
  // BACKEND INTEGRATION — HDS-03
  // Reemplazar este bloque mock por la llamada real al endpoint:
  // GET /api/v1/transactions
  // Headers requeridos:
  //   Authorization: Bearer {jwt_token}
  //   X-Tenant-ID: {tenant_id}
  //   X-Correlation-ID: {uuid}
  // Query params: { accountId?, page?, limit? }
  // Response esperado: { transactions: [...] }
  // ─────────────────────────────────────────
  Future<List<Transaction>> getTransactions(String tenantId) async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      Transaction(
        id: 'txn_001',
        type: TransactionType.deposit,
        status: TransactionStatus.completed,
        amount: 500000,
        currency: 'COP',
        accountId: 'acc_001',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        description: 'Depósito en efectivo',
      ),
      Transaction(
        id: 'txn_002',
        type: TransactionType.transfer,
        status: TransactionStatus.completed,
        amount: 200000,
        currency: 'COP',
        accountId: 'acc_001',
        destinationAccountId: 'acc_002',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        description: 'Transferencia a cuenta USD',
      ),
      Transaction(
        id: 'txn_003',
        type: TransactionType.withdrawal,
        status: TransactionStatus.failed,
        amount: 100000,
        currency: 'COP',
        accountId: 'acc_001',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        description: 'Retiro cajero',
      ),
      Transaction(
        id: 'txn_004',
        type: TransactionType.deposit,
        status: TransactionStatus.completed,
        amount: 300,
        currency: 'USD',
        accountId: 'acc_002',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        description: 'Depósito internacional',
      ),
      Transaction(
        id: 'txn_005',
        type: TransactionType.transfer,
        status: TransactionStatus.pending,
        amount: 150000,
        currency: 'COP',
        accountId: 'acc_001',
        destinationAccountId: 'acc_003',
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
        description: 'Transferencia pendiente',
      ),
    ];
  }

  Future<Transaction> getTransactionById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final transactions = await getTransactions('');
    return transactions.firstWhere(
      (t) => t.id == id,
      orElse: () => throw Exception('Transacción no encontrada'),
    );
  }
}