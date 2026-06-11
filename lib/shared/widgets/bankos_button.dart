import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

enum BankOsButtonVariant { primary, secondary }

class BankOsButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final BankOsButtonVariant variant;
  final bool isLoading;

  const BankOsButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = BankOsButtonVariant.primary,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              color: AppColors.onPrimary,
              strokeWidth: 2,
            ),
          )
        : Text(label);

    if (variant == BankOsButtonVariant.primary) {
      return ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: child,
      );
    }

    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      child: child,
    );
  }
}