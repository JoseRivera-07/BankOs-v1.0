import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/transaction_models.dart';
import '../providers/transactions_provider.dart';

class TransactionDetailScreen extends ConsumerWidget {
  final String transactionId;

  const TransactionDetailScreen({super.key, required this.transactionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionAsync = ref.watch(transactionDetailProvider(transactionId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => context.go(AppRoutes.history),
        ),
        title: Text(
          'Detalle',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SafeArea(
        child: transactionAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (e, _) => Center(
            child: Text(
              'Error: $e',
              style: TextStyle(color: AppColors.error),
            ),
          ),
          data: (transaction) => SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Estado ─────────────────────────────
                _DetailCard(
                  children: [
                    _StatusBadge(status: transaction.status),
                    const SizedBox(height: 16),
                    _DetailRow(
                      label: 'Tipo',
                      value: _typeLabel(transaction.type),
                    ),
                    _DetailRow(
                      label: 'Monto',
                      value: _formatAmount(transaction),
                    ),
                    _DetailRow(
                      label: 'Fecha',
                      value: DateFormat('dd MMM yyyy, HH:mm', 'es')
                          .format(transaction.createdAt),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // ── Cuentas ────────────────────────────
                _DetailCard(
                  children: [
                    _DetailRow(
                      label: 'Cuenta origen',
                      value: transaction.accountId,
                    ),
                    if (transaction.destinationAccountId != null)
                      _DetailRow(
                        label: 'Cuenta destino',
                        value: transaction.destinationAccountId!,
                      ),
                    if (transaction.description != null)
                      _DetailRow(
                        label: 'Descripción',
                        value: transaction.description!,
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                // ── ID ─────────────────────────────────
                _DetailCard(
                  children: [
                    _DetailRow(
                      label: 'ID transacción',
                      value: transaction.id,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _typeLabel(TransactionType type) {
    switch (type) {
      case TransactionType.deposit:
        return 'Depósito';
      case TransactionType.withdrawal:
        return 'Retiro';
      case TransactionType.transfer:
        return 'Transferencia';
    }
  }

  String _formatAmount(Transaction transaction) {
    final formatter = NumberFormat.currency(
      locale: transaction.currency == 'COP' ? 'es_CO' : 'en_US',
      symbol: transaction.currency == 'COP' ? '\$' : 'USD ',
      decimalDigits: transaction.currency == 'COP' ? 0 : 2,
    );
    return formatter.format(transaction.amount);
  }
}

class _DetailCard extends StatelessWidget {
  final List<Widget> children;

  const _DetailCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

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

class _StatusBadge extends StatelessWidget {
  final TransactionStatus status;

  const _StatusBadge({required this.status});

  String get _label {
    switch (status) {
      case TransactionStatus.completed:
        return 'Completada';
      case TransactionStatus.pending:
        return 'Pendiente';
      case TransactionStatus.failed:
        return 'Fallida';
    }
  }

  Color get _color {
    switch (status) {
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        _label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: _color,
            ),
      ),
    );
  }
}