import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/operations_repository.dart';
import '../../domain/operation_models.dart';
import '../../../../core/utils/idempotency_helper.dart';
final operationsRepositoryProvider = Provider<OperationsRepository>((ref) {
  return OperationsRepository();
});

enum OperationStatus { initial, loading, success, error }

class OperationState {
  final OperationStatus status;
  final OperationResult? result;
  final String? errorMessage;

  const OperationState({
    this.status = OperationStatus.initial,
    this.result,
    this.errorMessage,
  });

  OperationState copyWith({
    OperationStatus? status,
    OperationResult? result,
    String? errorMessage,
  }) {
    return OperationState(
      status: status ?? this.status,
      result: result ?? this.result,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class OperationsNotifier extends StateNotifier<OperationState> {
  final OperationsRepository _repository;

  OperationsNotifier(this._repository) : super(const OperationState());

  Future<void> deposit({
    required String accountId,
    required double amount,
    required String currency,
  }) async {
    state = state.copyWith(status: OperationStatus.loading);
    try {
      final result = await _repository.deposit(
        DepositRequest(
          accountId: accountId,
          amount: amount,
          currency: currency,
          idempotencyKey: IdempotencyHelper.generate(),
        ),
      );
      state = state.copyWith(
        status: result.success ? OperationStatus.success : OperationStatus.error,
        result: result,
        errorMessage: result.errorMessage,
      );
    } catch (e) {
      state = state.copyWith(
        status: OperationStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> withdrawal({
    required String accountId,
    required double amount,
    required String currency,
    required String pin,
  }) async {
    state = state.copyWith(status: OperationStatus.loading);
    try {
      final result = await _repository.withdrawal(
        WithdrawalRequest(
          accountId: accountId,
          amount: amount,
          currency: currency,
          pin: pin,
          idempotencyKey: IdempotencyHelper.generate(),
        ),
      );
      state = state.copyWith(
        status: result.success ? OperationStatus.success : OperationStatus.error,
        result: result,
        errorMessage: result.errorMessage,
      );
    } catch (e) {
      state = state.copyWith(
        status: OperationStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> transfer({
    required String sourceAccountId,
    required String destinationAccountId,
    required double amount,
    required String currency,
    required String pin,
  }) async {
    state = state.copyWith(status: OperationStatus.loading);
    try {
      final result = await _repository.transfer(
        TransferRequest(
          sourceAccountId: sourceAccountId,
          destinationAccountId: destinationAccountId,
          amount: amount,
          currency: currency,
          pin: pin,
          idempotencyKey: IdempotencyHelper.generate(),
        ),
      );
      state = state.copyWith(
        status: result.success ? OperationStatus.success : OperationStatus.error,
        result: result,
        errorMessage: result.errorMessage,
      );
    } catch (e) {
      state = state.copyWith(
        status: OperationStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  void reset() {
    state = const OperationState();
  }
}

final operationsProvider =
    StateNotifierProvider<OperationsNotifier, OperationState>((ref) {
  final repository = ref.watch(operationsRepositoryProvider);
  return OperationsNotifier(repository);
});