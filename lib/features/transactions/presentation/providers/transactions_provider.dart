import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/transactions_repository.dart';
import '../../domain/transaction_models.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

final transactionsRepositoryProvider = Provider<TransactionsRepository>((ref) {
  return TransactionsRepository();
});

final transactionsProvider = FutureProvider<List<Transaction>>((ref) async {
  final repository = ref.watch(transactionsRepositoryProvider);
  final authState = ref.watch(authProvider);
  final tenantId = authState.user?.tenantId ?? '';
  return repository.getTransactions(tenantId);
});

final transactionDetailProvider =
    FutureProvider.family<Transaction, String>((ref, id) async {
  final repository = ref.watch(transactionsRepositoryProvider);
  return repository.getTransactionById(id);
});