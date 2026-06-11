import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../dashboard/presentation/providers/accounts_provider.dart';

class TransferScreen extends ConsumerStatefulWidget {
  const TransferScreen({super.key});

  @override
  ConsumerState<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends ConsumerState<TransferScreen> {
  final _amountController = TextEditingController();
  String? _sourceAccountId;
  String? _destinationAccountId;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _onContinue() {
    final amount = double.tryParse(_amountController.text.trim());

    if (_sourceAccountId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona una cuenta origen')),
      );
      return;
    }

    if (_destinationAccountId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona una cuenta destino')),
      );
      return;
    }

    if (_sourceAccountId == _destinationAccountId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Las cuentas origen y destino deben ser diferentes')),
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
    final sourceAccount =
        accounts.firstWhere((a) => a.id == _sourceAccountId);

    ref.read(selectedAccountProvider.notifier).state = sourceAccount;

    context.go(
      AppRoutes.transactionSummary,
      extra: {
        'type': 'transfer',
        'accountId': _sourceAccountId,
        'destinationAccountId': _destinationAccountId,
        'amount': amount,
        'currency': sourceAccount.currency,
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
          'Transferir',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Cuenta origen ──────────────────────
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
                    initialValue: _sourceAccountId,
                    hint: const Text('Selecciona cuenta origen'),
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
                        setState(() => _sourceAccountId = value),
                  );
                },
              ),
              const SizedBox(height: 24),
              // ── Cuenta destino ─────────────────────
              Text(
                'Cuenta destino',
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
                    initialValue: _destinationAccountId,
                    hint: const Text('Selecciona cuenta destino'),
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
                        setState(() => _destinationAccountId = value),
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