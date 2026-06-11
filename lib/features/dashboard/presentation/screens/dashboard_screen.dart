import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/accounts_provider.dart';
import '../../domain/account_models.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountsProvider);
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          'BankOS',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.primary,
              ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.onSurfaceVariant),
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) context.go(AppRoutes.login);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Saludo ─────────────────────────────
              Text(
                'Hola, ${authState.user?.role == 'admin' ? 'Administrador' : 'Cliente'}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              Text(
                authState.user?.email ?? '',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 32),
              // ── Cuentas ────────────────────────────
              Text(
                'Mis cuentas',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 12),
              accountsAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
                error: (e, _) => Text(
                  'Error cargando cuentas: $e',
                  style: TextStyle(color: AppColors.error),
                ),
                data: (accounts) => Column(
                  children: accounts
                      .map((account) => _AccountCard(account: account))
                      .toList(),
                ),
              ),
              const SizedBox(height: 32),
              // ── Acciones rápidas ───────────────────
              Text(
                'Operaciones',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.add,
                      label: 'Depositar',
                      onTap: () => context.go(AppRoutes.deposit),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.remove,
                      label: 'Retirar',
                      onTap: () => context.go(AppRoutes.withdrawal),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.swap_horiz,
                      label: 'Transferir',
                      onTap: () => context.go(AppRoutes.transfer),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // ── Historial ──────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Movimientos recientes',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                  TextButton(
                    onPressed: () => context.go(AppRoutes.history),
                    child: Text(
                      'Ver todo',
                      style: TextStyle(color: AppColors.primary),
                    ),
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

class _AccountCard extends StatelessWidget {
  final Account account;

  const _AccountCard({required this.account});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: account.currency == 'COP' ? 'es_CO' : 'en_US',
      symbol: account.currency == 'COP' ? '\$' : 'USD ',
      decimalDigits: account.currency == 'COP' ? 0 : 2,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cuenta ${account.number}',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  formatter.format(account.balance),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: account.isActive
                            ? AppColors.onSurface
                            : AppColors.outline,
                      ),
                ),
              ],
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: account.isActive
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : AppColors.outline.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                account.isActive ? 'Activa' : 'Inactiva',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: account.isActive
                          ? AppColors.primary
                          : AppColors.outline,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
      borderRadius: BorderRadius.circular(8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(height: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.onSurface,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}