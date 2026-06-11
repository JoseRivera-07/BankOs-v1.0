import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../features/transactions/domain/transaction_models.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;

  const TransactionTile({super.key, required this.transaction});

  IconData get _icon {
    switch (transaction.type) {
      case TransactionType.deposit:
        return Icons.arrow_downward;
      case TransactionType.withdrawal:
        return Icons.arrow_upward;
      case TransactionType.transfer:
        return Icons.swap_horiz;
    }
  }

  Color get _iconColor {
    switch (transaction.type) {
      case TransactionType.deposit:
        return AppColors.primary;
      case TransactionType.withdrawal:
        return AppColors.error;
      case TransactionType.transfer:
        return AppColors.secondary;
    }
  }

  String get _typeLabel {
    switch (transaction.type) {
      case TransactionType.deposit:
        return 'Depósito';
      case TransactionType.withdrawal:
        return 'Retiro';
      case TransactionType.transfer:
        return 'Transferencia';
    }
  }

  String get _statusLabel {
    switch (transaction.status) {
      case TransactionStatus.completed:
        return 'Completada';
      case TransactionStatus.pending:
        return 'Pendiente';
      case TransactionStatus.failed:
        return 'Fallida';
    }
  }

  Color get _statusColor {
    switch (transaction.status) {
      case TransactionStatus.completed:
        return AppColors.primary;
      case TransactionStatus.pending:
        return AppColors.secondary;
      case TransactionStatus.failed:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: transaction.currency == 'COP' ? 'es_CO' : 'en_US',
      symbol: transaction.currency == 'COP' ? '\$' : 'USD ',
      decimalDigits: transaction.currency == 'COP' ? 0 : 2,
    );

    final dateFormatter = DateFormat('dd MMM yyyy, HH:mm', 'es');

    return Card(
      child: InkWell(
        onTap: () => context.go('/transaction/${transaction.id}'),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // ── Icono ──────────────────────────────
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(_icon, color: _iconColor, size: 20),
              ),
              const SizedBox(width: 16),
              // ── Info ───────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _typeLabel,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dateFormatter.format(transaction.createdAt),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              // ── Monto y estado ─────────────────────
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatter.format(transaction.amount),
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: _iconColor),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _statusLabel,
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: _statusColor),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}