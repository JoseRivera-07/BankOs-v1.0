import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';

class TransactionSummaryScreen extends ConsumerWidget {
  final Map<String, dynamic> data;

  const TransactionSummaryScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = data['type'] as String;
    final amount = data['amount'] as double;
    final currency = data['currency'] as String;
    final accountId = data['accountId'] as String;
    final destinationAccountId = data['destinationAccountId'] as String?;

    final formatter = NumberFormat.currency(
      locale: currency == 'COP' ? 'es_CO' : 'en_US',
      symbol: currency == 'COP' ? '\$' : 'USD ',
      decimalDigits: currency == 'COP' ? 0 : 2,
    );

    final fee = type == 'transfer'
        ? amount * AppConstants.transferFeePercent
        : 0.0;
    final total = amount + fee;

    String typeLabel() {
      switch (type) {
        case 'deposit':
          return 'Depósito';
        case 'withdrawal':
          return 'Retiro';
        case 'transfer':
          return 'Transferencia';
        default:
          return type;
      }
    }

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
          'Resumen',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Detalle operación ──────────────────
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SummaryRow(
                        label: 'Operación',
                        value: typeLabel(),
                      ),
                      _SummaryRow(
                        label: 'Cuenta origen',
                        value: accountId,
                      ),
                      if (destinationAccountId != null)
                        _SummaryRow(
                          label: 'Cuenta destino',
                          value: destinationAccountId,
                        ),
                      _SummaryRow(
                        label: 'Monto',
                        value: formatter.format(amount),
                      ),
                      if (fee > 0)
                        _SummaryRow(
                          label: 'Comisión (1.5%)',
                          value: formatter.format(fee),
                        ),
                      const Divider(height: 24),
                      _SummaryRow(
                        label: 'Total',
                        value: formatter.format(total),
                        isTotal: true,
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              // ── Botón confirmar ────────────────────
              ElevatedButton(
                onPressed: () => context.go(
                  AppRoutes.pinConfirmation,
                  extra: data,
                ),
                child: const Text('Confirmar con PIN'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.pop(),
                child: const Text('Cancelar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

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
            style: isTotal
                ? Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.primary,
                    )
                : Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}