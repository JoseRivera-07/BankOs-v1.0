import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../dashboard/presentation/providers/accounts_provider.dart';

class WithdrawalScreen extends ConsumerStatefulWidget {
  const WithdrawalScreen({super.key});

  @override
  ConsumerState<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends ConsumerState<WithdrawalScreen> {
  final _amountController = TextEditingController();
  String? _selectedAccountId;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _onContinue() {
    final amount = double.tryParse(_amountController.text.trim());

    if (_selectedAccountId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona una cuenta')),
      );
      return;
    }

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa un monto válido')),
      );
      return;
    }

    final accounts = ref.read(accountsProvider).value ?? [];
    final account = accounts.firstWhere((a) => a.id == _selectedAccountId);

    ref.read(selectedAccountProvider.notifier).state = account;

    context.go(
      AppRoutes.transactionSummary,
      extra: {
        'type': 'withdrawal',
        'accountId': _selectedAccountId,
        'amount': amount,
        'currency': account.currency,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final accountsAsync = ref.watch(accountsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => context.go(AppRoutes.dashboard),
        ),
        title: Text(
          'Retirar',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Selección de cuenta ────────────────
              Text(
                'Cuenta origen',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 8),
              accountsAsync.when(
                loading: () => const CircularProgressIndicator(
                  color: AppColors.primary,
                ),
                error: (e, _) => Text('Error: $e'),
                data: (accounts) {
                  final activeAccounts =
                      accounts.where((a) => a.isActive).toList();
                  return DropdownButtonFormField<String>(
                    initialValue: _selectedAccountId,
                    hint: const Text('Selecciona una cuenta'),
                    decoration: const InputDecoration(),
                    items: activeAccounts
                        .map(
                          (a) => DropdownMenuItem(
                            value: a.id,
                            child: Text('${a.number} — ${a.currency}'),
                          ),
                        )
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _selectedAccountId = value),
                  );
                },
              ),
              const SizedBox(height: 24),
              // ── Monto ──────────────────────────────
              Text(
                'Monto',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  hintText: '0.00',
                  prefixText: '\$ ',
                ),
              ),
              const SizedBox(height: 32),
              // ── Botón continuar ────────────────────
              ElevatedButton(
                onPressed: _onContinue,
                child: const Text('Continuar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}