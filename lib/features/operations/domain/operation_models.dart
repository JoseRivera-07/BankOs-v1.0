import 'package:flutter/foundation.dart';

@immutable
class DepositRequest {
  final String accountId;
  final double amount;
  final String currency;
  final String idempotencyKey;

  const DepositRequest({
    required this.accountId,
    required this.amount,
    required this.currency,
    required this.idempotencyKey,
  });
}

@immutable
class WithdrawalRequest {
  final String accountId;
  final double amount;
  final String currency;
  final String pin;
  final String idempotencyKey;

  const WithdrawalRequest({
    required this.accountId,
    required this.amount,
    required this.currency,
    required this.pin,
    required this.idempotencyKey,
  });
}

@immutable
class TransferRequest {
  final String sourceAccountId;
  final String destinationAccountId;
  final double amount;
  final String currency;
  final String pin;
  final String idempotencyKey;

  const TransferRequest({
    required this.sourceAccountId,
    required this.destinationAccountId,
    required this.amount,
    required this.currency,
    required this.pin,
    required this.idempotencyKey,
  });
}

@immutable
class OperationResult {
  final String transactionId;
  final bool success;
  final String? errorMessage;
  final double? fee;
  final double? finalAmount;

  const OperationResult({
    required this.transactionId,
    required this.success,
    this.errorMessage,
    this.fee,
    this.finalAmount,
  });

  factory OperationResult.fromJson(Map<String, dynamic> json) =>
      OperationResult(
        transactionId: json['transactionId'] as String,
        success: json['success'] as bool,
        errorMessage: json['errorMessage'] as String?,
        fee: (json['fee'] as num?)?.toDouble(),
        finalAmount: (json['finalAmount'] as num?)?.toDouble(),
      );
}