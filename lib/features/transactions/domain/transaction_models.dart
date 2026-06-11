import 'package:flutter/foundation.dart';

enum TransactionType { deposit, withdrawal, transfer }

enum TransactionStatus { pending, completed, failed }

@immutable
class Transaction {
  final String id;
  final TransactionType type;
  final TransactionStatus status;
  final double amount;
  final String currency;
  final String accountId;
  final String? destinationAccountId;
  final DateTime createdAt;
  final String? description;

  const Transaction({
    required this.id,
    required this.type,
    required this.status,
    required this.amount,
    required this.currency,
    required this.accountId,
    this.destinationAccountId,
    required this.createdAt,
    this.description,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json['id'] as String,
        type: TransactionType.values.byName(json['type'] as String),
        status: TransactionStatus.values.byName(json['status'] as String),
        amount: (json['amount'] as num).toDouble(),
        currency: json['currency'] as String,
        accountId: json['accountId'] as String,
        destinationAccountId: json['destinationAccountId'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
        description: json['description'] as String?,
      );
}