import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../features/dashboard/domain/account_models.dart';

class AccountCard extends StatelessWidget {
  final Account account;
  final VoidCallback? onTap;

  const AccountCard({
    super.key,
    required this.account,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: account.currency == 'COP' ? 'es_CO' : 'en_US',
      symbol: account.currency == 'COP' ? '\$' : 'USD ',
      decimalDigits: account.currency == 'COP' ? 0 : 2,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
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
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(
                          color: account.isActive
                              ? AppColors.onSurface
                              : AppColors.outline,
                        ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
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
      ),
    );
  }
}