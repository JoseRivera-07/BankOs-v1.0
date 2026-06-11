import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _tenantController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _tenantController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    await ref.read(authProvider.notifier).login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          _tenantController.text.trim().isEmpty
              ? 'bancolombia-demo'
              : _tenantController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen(authProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        context.go(AppRoutes.dashboard);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 48),
              // ── Logo ───────────────────────────────
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: AppColors.onPrimary,
                  size: 48,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'BankOs',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 32),
              // ── Card formulario ────────────────────
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bienvenido de nuevo',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(color: AppColors.onSurface),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ingresa tus credenciales para continuar',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 24),
                      // ── Tenant Slug ────────────────
                      Text(
                        'Tenant Slug',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _tenantController,
                        decoration: const InputDecoration(
                          hintText: 'empresa-id',
                          prefixIcon: Icon(
                            Icons.grid_view_rounded,
                            color: AppColors.outline,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // ── Usuario ────────────────────
                      Text(
                        'Usuario',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'tu.usuario',
                          prefixIcon: Icon(
                            Icons.person_outline_rounded,
                            color: AppColors.outline,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // ── Contraseña ─────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Contraseña',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Olvidé mi contraseña',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(color: AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          prefixIcon: const Icon(
                            Icons.lock_outline_rounded,
                            color: AppColors.outline,
                            size: 20,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.outline,
                              size: 20,
                            ),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                        ),
                      ),
                      // ── Error ──────────────────────
                      if (authState.status == AuthStatus.error)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            authState.errorMessage ?? 'Error desconocido',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: AppColors.error),
                          ),
                        ),
                      const SizedBox(height: 24),
                      // ── Botón login ────────────────
                      ElevatedButton(
                        onPressed: authState.status == AuthStatus.loading
                            ? null
                            : _onLogin,
                        child: authState.status == AuthStatus.loading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: AppColors.onPrimary,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Iniciar Sesión'),
                      ),
                      const SizedBox(height: 24),
                      // ── Divisor biométrico ─────────
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(color: AppColors.outlineVariant),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'O ingresa con',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: AppColors.onSurfaceVariant),
                            ),
                          ),
                          const Expanded(
                            child: Divider(color: AppColors.outlineVariant),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // ── Biométrico ─────────────────
                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerLow,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.outlineVariant,
                                ),
                              ),
                              child: const Icon(
                                Icons.fingerprint_rounded,
                                color: AppColors.primary,
                                size: 28,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Acceso biométrico',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(color: AppColors.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // ── Footer ─────────────────────────────
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                  children: [
                    const TextSpan(text: '¿No tienes una cuenta? '),
                    TextSpan(
                      text: 'Contacta a soporte',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Privacidad',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Términos',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Ayuda',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}