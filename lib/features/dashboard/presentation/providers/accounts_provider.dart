import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/accounts_repository.dart';
import '../../domain/account_models.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

final accountsRepositoryProvider = Provider<AccountsRepository>((ref) {
  return AccountsRepository();
});

final accountsProvider = FutureProvider<List<Account>>((ref) async {
  final repository = ref.watch(accountsRepositoryProvider);
  final authState = ref.watch(authProvider);
  final tenantId = authState.user?.tenantId ?? '';
  return repository.getAccounts(tenantId);
});

final selectedAccountProvider = StateProvider<Account?>((ref) => null);