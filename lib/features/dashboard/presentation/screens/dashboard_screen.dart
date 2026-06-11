import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/accounts_provider.dart';
import '../../../transactions/presentation/providers/transactions_provider.dart';
import '../../domain/account_models.dart';
import '../../../transactions/domain/transaction_models.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountsProvider);
    final transactionsAsync = ref.watch(transactionsProvider);
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: _BottomNav(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) context.go(AppRoutes.history);
          if (index == 2) context.go(AppRoutes.deposit);
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // ── Header ─────────────────────────────
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: AppColors.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'HOLA,',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(color: AppColors.onSurfaceVariant),
                        ),
                        Text(
                          '${authState.user?.email.split('@').first ?? 'Usuario'} — BankOs',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: AppColors.onSurface,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // ── Balance card ───────────────────────
              accountsAsync.when(
                loading: () => const _BalanceCardSkeleton(),
                error: (e, _) => const SizedBox(),
                data: (accounts) {
                  final total = accounts
                      .where((a) => a.isActive && a.currency == 'COP')
                      .fold(0.0, (sum, a) => sum + a.balance);
                  return _BalanceCard(total: total);
                },
              ),
              const SizedBox(height: 20),
              // ── Acciones rápidas ───────────────────
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.send_rounded,
                      label: 'Enviar',
                      onTap: () => context.go(AppRoutes.transfer),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.call_received_rounded,
                      label: 'Recibir',
                      onTap: () => context.go(AppRoutes.deposit),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.payment_rounded,
                      label: 'Pagar',
                      onTap: () => context.go(AppRoutes.withdrawal),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              // ── Mis cuentas ────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mis Cuentas',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Ver todas',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              accountsAsync.when(
                loading: () => const CircularProgressIndicator(
                  color: AppColors.primary,
                ),
                error: (e, _) => Text(
                  'Error: $e',
                  style: const TextStyle(color: AppColors.error),
                ),
                data: (accounts) => Column(
                  children: accounts
                      .where((a) => a.isActive)
                      .map((a) => _AccountRow(account: a))
                      .toList(),
                ),
              ),
              const SizedBox(height: 28),
              // ── Movimientos recientes ──────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Movimientos',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  TextButton(
                    onPressed: () => context.go(AppRoutes.history),
                    child: Text(
                      'Ver historial',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              transactionsAsync.when(
                loading: () => const CircularProgressIndicator(
                  color: AppColors.primary,
                ),
                error: (e, _) => Text(
                  'Error: $e',
                  style: const TextStyle(color: AppColors.error),
                ),
                data: (transactions) => Card(
                  child: Column(
                    children: transactions
                        .take(3)
                        .toList()
                        .asMap()
                        .entries
                        .map((entry) {
                      final isLast =
                          entry.key == transactions.take(3).length - 1;
                      return Column(
                        children: [
                          _TransactionRow(transaction: entry.value),
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
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Balance Card ─────────────────────────────
class _BalanceCard extends StatelessWidget {
  final double total;

  const _BalanceCard({required this.total});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: 'es_CO',
      symbol: '\$ ',
      decimalDigits: 2,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // Círculo decorativo
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Saldo Total en BankOs',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onPrimaryContainer,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                formatter.format(total),
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: AppColors.onPrimary,
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.trending_up_rounded,
                    color: AppColors.onPrimaryContainer,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '+2.4% este mes',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onPrimaryContainer,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BalanceCardSkeleton extends StatelessWidget {
  const _BalanceCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.onPrimary),
      ),
    );
  }
}

// ── Action Button ─────────────────────────────
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.actionBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurface,
                ),
          ),
        ],
      ),
    );
  }
}

// ── Account Row ───────────────────────────────
class _AccountRow extends StatelessWidget {
  final Account account;

  const _AccountRow({required this.account});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: account.currency == 'COP' ? 'es_CO' : 'en_US',
      symbol: account.currency == 'COP' ? '\$ ' : 'USD ',
      decimalDigits: 2,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.secondaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.account_balance_outlined,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    account.currency == 'COP'
                        ? 'Cuenta Corriente'
                        : 'Ahorros',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Text(
                    '**** ${account.number.split('-').last}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            Text(
              formatter.format(account.balance),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Transaction Row ───────────────────────────
class _TransactionRow extends StatelessWidget {
  final Transaction transaction;

  const _TransactionRow({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: transaction.currency == 'COP' ? 'es_CO' : 'en_US',
      symbol: transaction.currency == 'COP' ? '\$ ' : 'USD ',
      decimalDigits: 2,
    );

    final isCredit = transaction.type == TransactionType.deposit;
    final amountColor =
        isCredit ? AppColors.creditGreen : AppColors.debitRed;
    final amountPrefix = isCredit ? '+ ' : '- ';

    IconData icon;
    switch (transaction.type) {
      case TransactionType.deposit:
        icon = Icons.payment_rounded;
        break;
      case TransactionType.withdrawal:
        icon = Icons.work_outline_rounded;
        break;
      case TransactionType.transfer:
        icon = Icons.swap_horiz_rounded;
        break;
    }

    return InkWell(
      onTap: () => context.go('/transaction/${transaction.id}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.onSurfaceVariant, size: 20),
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
                    _formatDate(transaction.createdAt),
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return 'Hoy, ${date.hour}:${date.minute.toString().padLeft(2, '0')} AM';
    if (diff.inDays == 1) return 'Ayer, ${date.hour}:${date.minute.toString().padLeft(2, '0')} PM';
    return '${date.day} ${_month(date.month)}, ${date.year}';
  }

  String _month(int m) {
    const months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    return months[m - 1];
  }
}

// ── Bottom Navigation ─────────────────────────
class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

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
        onTap: onTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long_rounded),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz_rounded),
            label: 'Operations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}