import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bank_os/features/auth/presentation/screens/login_screen.dart';


abstract final class AppRoutes {
  static const login = '/login';
  static const dashboard = '/dashboard';
  static const history = '/history';
  static const transactionDetail = '/transaction/:id';
  static const deposit = '/deposit';
  static const withdrawal = '/withdrawal';
  static const transfer = '/transfer';
  static const transactionSummary = '/transaction-summary';
  static const pinConfirmation = '/pin-confirmation';
  static const operationStatus = '/operation-status';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.login,
  routes: [
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.dashboard,
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('Dashboard — coming soon')),
      ),
    ),
    GoRoute(
      path: AppRoutes.history,
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('History — coming soon')),
      ),
    ),
    GoRoute(
      path: AppRoutes.transactionDetail,
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('Transaction Detail — coming soon')),
      ),
    ),
    GoRoute(
      path: AppRoutes.deposit,
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('Deposit — coming soon')),
      ),
    ),
    GoRoute(
      path: AppRoutes.withdrawal,
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('Withdrawal — coming soon')),
      ),
    ),
    GoRoute(
      path: AppRoutes.transfer,
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('Transfer — coming soon')),
      ),
    ),
    GoRoute(
      path: AppRoutes.transactionSummary,
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('Transaction Summary — coming soon')),
      ),
    ),
    GoRoute(
      path: AppRoutes.pinConfirmation,
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('Pin Confirmation — coming soon')),
      ),
    ),
    GoRoute(
      path: AppRoutes.operationStatus,
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('Operation Status — coming soon')),
      ),
    ),
  ],
);