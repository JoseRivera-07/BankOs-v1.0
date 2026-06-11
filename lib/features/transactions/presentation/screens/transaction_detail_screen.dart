import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final transactionAsync =
        ref.watch(transactionDetailProvider(transactionId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primary),
          onPressed: () => context.go(AppRoutes.history),
        ),
        title: Text(
          'Detalle de Transacción',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.onSurface,
              ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.primary,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: transactionAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (e, _) => Center(
            child: Text('Error: $e',
                style: const TextStyle(color: AppColors.error)),
          ),
          data: (transaction) => SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // ── Estado y monto ─────────────────
                _StatusHeader(transaction: transaction),
                const SizedBox(height: 16),
                // ── Detalle card ───────────────────
                _DetailCard(transaction: transaction),
                const SizedBox(height: 16),
                // ── Info card ──────────────────────
                _InfoCard(),
                const SizedBox(height: 24),
                // ── Botón compartir ────────────────
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.share_rounded, size: 18),
                  label: const Text('Compartir Comprobante'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Reportar Problema',
                    style: TextStyle(
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Status Header ─────────────────────────────
class _StatusHeader extends StatelessWidget {
  final Transaction transaction;

  const _StatusHeader({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: transaction.currency == 'COP' ? 'es_CO' : 'en_US',
      symbol: transaction.currency == 'COP' ? '\$' : 'USD ',
      decimalDigits: 2,
    );

    final isCompleted = transaction.status == TransactionStatus.completed;

    return Column(
      children: [
        const SizedBox(height: 8),
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.secondaryContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            isCompleted
                ? Icons.check_circle_outline_rounded
                : transaction.status == TransactionStatus.pending
                    ? Icons.access_time_rounded
                    : Icons.error_outline_rounded,
            color: isCompleted ? AppColors.primary : AppColors.error,
            size: 36,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          isCompleted
              ? 'PAGO EXITOSO'
              : transaction.status == TransactionStatus.pending
                  ? 'PENDIENTE'
                  : 'PAGO FALLIDO',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.onSurfaceVariant,
                letterSpacing: 0.1,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          formatter.format(transaction.amount),
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: 40,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.verified_outlined,
              size: 16,
              color: AppColors.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Text(
              'Confirmado por el banco',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Detail Card ───────────────────────────────
class _DetailCard extends StatelessWidget {
  final Transaction transaction;

  const _DetailCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('dd MMM, yyyy • HH:mm', 'es');
    final isCompleted = transaction.status == TransactionStatus.completed;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _DetailRow(
              label: 'Estado',
              value: '',
              trailing: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppColors.onSurface
                      : AppColors.errorContainer,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  isCompleted
                      ? 'Completado'
                      : transaction.status == TransactionStatus.pending
                          ? 'Pendiente'
                          : 'Fallido',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isCompleted
                            ? AppColors.onPrimary
                            : AppColors.onErrorContainer,
                      ),
                ),
              ),
            ),
            const Divider(height: 24),
            _DetailRow(
              label: 'Fecha',
              value: dateFormatter.format(transaction.createdAt),
              valueBold: true,
            ),
            const Divider(height: 24),
            _DetailRow(
              label: 'Referencia',
              value: transaction.id.toUpperCase(),
              valueBold: true,
              trailing: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.copy_rounded,
                  size: 16,
                  color: AppColors.onSurfaceVariant,
                ),
                onPressed: () {
                  Clipboard.setData(
                      ClipboardData(text: transaction.id.toUpperCase()));
                },
              ),
            ),
            const Divider(height: 24),
            _DetailRow(
              label: 'Cuenta',
              value: '',
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Cuenta Corriente',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    '**** ${transaction.accountId.split('_').last.padLeft(4, '0')}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            const Divider(height: 24),
            _DetailRow(
              label: 'Categoría',
              value: '',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.shopping_basket_outlined,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _categoryLabel(transaction.type),
                    style:
                        Theme.of(context).textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _categoryLabel(TransactionType type) {
    switch (type) {
      case TransactionType.deposit:
        return 'Ingresos';
      case TransactionType.withdrawal:
        return 'Supermercado';
      case TransactionType.transfer:
        return 'Transferencia';
    }
  }
}

// ── Info Card ─────────────────────────────────
class _InfoCard extends StatelessWidget {
  const _InfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 20,
            color: AppColors.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¿Tienes dudas?',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Esta transacción ya ha sido procesada y no puede ser cancelada. Si ves un error, por favor repórtalo.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Detail Row ────────────────────────────────
class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool valueBold;
  final Widget? trailing;

  const _DetailRow({
    required this.label,
    required this.value,
    this.valueBold = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
        ),
        trailing ??
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight:
                        valueBold ? FontWeight.w600 : FontWeight.w400,
                    color: AppColors.onSurface,
                  ),
            ),
      ],
    );
  }
}