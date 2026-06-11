import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/operations_provider.dart';

class OperationStatusScreen extends ConsumerWidget {
  final Map<String, dynamic> data;

  const OperationStatusScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final operationState = ref.watch(operationsProvider);
    final currency = data['currency'] as String;
    final isSuccess = operationState.status == OperationStatus.success;

    final formatter = NumberFormat.currency(
      locale: currency == 'COP' ? 'es_CO' : 'en_US',
      symbol: currency == 'COP' ? '\$' : 'USD ',
      decimalDigits: currency == 'COP' ? 0 : 2,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── Icono estado ───────────────────────
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: isSuccess
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : AppColors.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isSuccess ? Icons.check_circle : Icons.error,
                  color: isSuccess ? AppColors.primary : AppColors.error,
                  size: 48,
                ),
              ),
              const SizedBox(height: 24),
              // ── Título ─────────────────────────────
              Text(
                isSuccess ? '¡Operación exitosa!' : 'Operación fallida',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color:
                          isSuccess ? AppColors.primary : AppColors.error,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                isSuccess
                    ? 'Tu operación fue procesada correctamente.'
                    : operationState.errorMessage ?? 'Ocurrió un error.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // ── Detalle resultado ──────────────────
              if (isSuccess && operationState.result != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        _ResultRow(
                          label: 'ID transacción',
                          value: operationState.result!.transactionId,
                        ),
                        if (operationState.result!.finalAmount != null)
                          _ResultRow(
                            label: 'Monto final',
                            value: formatter
                                .format(operationState.result!.finalAmount),
                          ),
                        if (operationState.result!.fee != null)
                          _ResultRow(
                            label: 'Comisión',
                            value: formatter
                                .format(operationState.result!.fee),
                          ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 32),
              // ── Botones ────────────────────────────
              ElevatedButton(
                onPressed: () {
                  ref.read(operationsProvider.notifier).reset();
                  context.go(AppRoutes.dashboard);
                },
                child: const Text('Volver al inicio'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  ref.read(operationsProvider.notifier).reset();
                  context.go(AppRoutes.history);
                },
                child: const Text('Ver historial'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;

  const _ResultRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}