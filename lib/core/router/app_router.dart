import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/transactions/presentation/screens/history_screen.dart';
import '../../features/transactions/presentation/screens/transaction_detail_screen.dart';
import '../../features/operations/presentation/screens/deposit_screen.dart';
import '../../features/operations/presentation/screens/withdrawal_screen.dart';
import '../../features/operations/presentation/screens/transfer_screen.dart';
import '../../features/operations/presentation/screens/transaction_summary_screen.dart';
import '../../features/operations/presentation/screens/pin_confirmation_screen.dart';
import '../../features/operations/presentation/screens/operation_status_screen.dart';

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
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: AppRoutes.history,
      builder: (context, state) => const HistoryScreen(),
    ),
    GoRoute(
      path: AppRoutes.transactionDetail,
      builder: (context, state) => TransactionDetailScreen(
        transactionId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: AppRoutes.deposit,
      builder: (context, state) => const DepositScreen(),
    ),
    GoRoute(
      path: AppRoutes.withdrawal,
      builder: (context, state) => const WithdrawalScreen(),
    ),
    GoRoute(
      path: AppRoutes.transfer,
      builder: (context, state) => const TransferScreen(),
    ),
    GoRoute(
      path: AppRoutes.transactionSummary,
      builder: (context, state) => TransactionSummaryScreen(
        data: state.extra as Map<String, dynamic>,
      ),
    ),
    GoRoute(
      path: AppRoutes.pinConfirmation,
      builder: (context, state) => PinConfirmationScreen(
        data: state.extra as Map<String, dynamic>,
      ),
    ),
    GoRoute(
      path: AppRoutes.operationStatus,
      builder: (context, state) => OperationStatusScreen(
        data: state.extra as Map<String, dynamic>,
      ),
    ),
  ],
);