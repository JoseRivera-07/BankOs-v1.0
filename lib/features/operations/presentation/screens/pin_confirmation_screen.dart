import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/operations_provider.dart';

class PinConfirmationScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;

  const PinConfirmationScreen({super.key, required this.data});

  @override
  ConsumerState<PinConfirmationScreen> createState() =>
      _PinConfirmationScreenState();
}

class _PinConfirmationScreenState extends ConsumerState<PinConfirmationScreen> {
  final _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _onConfirm() async {
    final pin = _pinController.text.trim();

    if (pin.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El PIN debe tener 4 dígitos')),
      );
      return;
    }

    final type = widget.data['type'] as String;
    final accountId = widget.data['accountId'] as String;
    final amount = widget.data['amount'] as double;
    final currency = widget.data['currency'] as String;
    final notifier = ref.read(operationsProvider.notifier);
    final router = GoRouter.of(context);

    switch (type) {
      case 'deposit':
        await notifier.deposit(
          accountId: accountId,
          amount: amount,
          currency: currency,
        );
        break;
      case 'withdrawal':
        await notifier.withdrawal(
          accountId: accountId,
          amount: amount,
          currency: currency,
          pin: pin,
        );
        break;
      case 'transfer':
        await notifier.transfer(
          sourceAccountId: accountId,
          destinationAccountId: widget.data['destinationAccountId'] as String,
          amount: amount,
          currency: currency,
          pin: pin,
        );
        break;
    }

    if (!mounted) return;
    router.go(AppRoutes.operationStatus, extra: widget.data);
  }

  @override
  Widget build(BuildContext context) {
    final operationState = ref.watch(operationsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Confirmar PIN',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Text(
                'Ingresa tu PIN de seguridad',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Para confirmar la operación ingresa tu PIN de 4 dígitos.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),
              // ── PIN input ──────────────────────────
              TextField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 4,
                decoration: const InputDecoration(
                  hintText: '••••',
                  counterText: '',
                ),
              ),
              const SizedBox(height: 32),
              // ── Botón confirmar ────────────────────
              ElevatedButton(
                onPressed: operationState.status == OperationStatus.loading
                    ? null
                    : _onConfirm,
                child: operationState.status == OperationStatus.loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: AppColors.onPrimary,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Confirmar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
