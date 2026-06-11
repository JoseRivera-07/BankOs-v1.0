import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/transaction_models.dart';
import '../providers/transactions_provider.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primary),
          onPressed: () => context.go(AppRoutes.dashboard),
        ),
        title: Text(
          'Historial',
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
      bottomNavigationBar: _BottomNav(currentIndex: 1),
      body: SafeArea(
        child: Column(
          children: [
            // ── Filtros ────────────────────────────
            SizedBox(
              height: 48,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                children: [
                  _FilterChip(
                    icon: Icons.calendar_month_outlined,
                    label: 'Rango de fechas',
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    icon: Icons.filter_alt_outlined,
                    label: 'Tipo',
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    icon: Icons.check_circle_outline_rounded,
                    label: 'Estado',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // ── Lista ──────────────────────────────
            Expanded(
              child: transactionsAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
                error: (e, _) => Center(
                  child: Text(
                    'Error: $e',
                    style: const TextStyle(color: AppColors.error),
                  ),
                ),
                data: (transactions) {
                  final grouped = _groupByDate(transactions);
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: grouped.length,
                    itemBuilder: (context, index) {
                      final entry = grouped.entries.elementAt(index);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              entry.key,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                    letterSpacing: 0.08,
                                  ),
                            ),
                          ),
                          Card(
                            child: Column(
                              children: entry.value
                                  .asMap()
                                  .entries
                                  .map((e) {
                                final isLast =
                                    e.key == entry.value.length - 1;
                                return Column(
                                  children: [
                                    _TransactionTile(
                                        transaction: e.value),
                                    if (!isLast)
                                      const Divider(
                                        height: 1,
                                        indent: 16,
                                        endIndent: 16,
                                      ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, List<Transaction>> _groupByDate(List<Transaction> transactions) {
    final Map<String, List<Transaction>> grouped = {};
    final now = DateTime.now();

    for (final t in transactions) {
      final diff = now.difference(t.createdAt).inDays;
      String key;
      if (diff == 0) {
        key = 'HOY';
      } else if (diff == 1) {
        key = 'AYER';
      } else {
        key = DateFormat('dd MMM, yyyy', 'es').format(t.createdAt).toUpperCase();
      }
      grouped.putIfAbsent(key, () => []).add(t);
    }
    return grouped;
  }
}

// ── Filter Chip ───────────────────────────────
class _FilterChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FilterChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurface,
                ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 16,
            color: AppColors.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}

// ── Transaction Tile ──────────────────────────
class _TransactionTile extends StatelessWidget {
  final Transaction transaction;

  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: transaction.currency == 'COP' ? 'es_CO' : 'en_US',
      symbol: transaction.currency == 'COP' ? '\$' : 'USD ',
      decimalDigits: 2,
    );

    final isCredit = transaction.type == TransactionType.deposit;
    final amountColor =
        isCredit ? AppColors.creditGreen : AppColors.debitRed;
    final amountPrefix = isCredit ? '+' : '-';

    IconData icon;
    String category;
    switch (transaction.type) {
      case TransactionType.deposit:
        icon = Icons.payment_rounded;
        category = 'Ingresos';
        break;
      case TransactionType.withdrawal:
        icon = Icons.shopping_cart_outlined;
        category = 'Compras';
        break;
      case TransactionType.transfer:
        icon = Icons.swap_horiz_rounded;
        category = 'Transferencias';
        break;
    }

    return InkWell(
      onTap: () => context.go('/transaction/${transaction.id}'),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.secondaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.description ?? 'Transacción',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  Text(
                    category,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            Text(
              '$amountPrefix${formatter.format(transaction.amount)}',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: amountColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Bottom Navigation ─────────────────────────
class _BottomNav extends StatelessWidget {
  final int currentIndex;

  const _BottomNav({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.outlineVariant),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == 0) context.go(AppRoutes.dashboard);
          if (index == 2) context.go(AppRoutes.deposit);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long_rounded),
            label: 'Movimientos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz_rounded),
            label: 'Operar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}