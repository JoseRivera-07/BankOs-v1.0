import 'package:flutter/foundation.dart';

@immutable
class Account {
  final String id;
  final String number;
  final String currency;
  final double balance;
  final bool isActive;

  const Account({
    required this.id,
    required this.number,
    required this.currency,
    required this.balance,
    required this.isActive,
  });

  factory Account.fromJson(Map<String, dynamic> json) => Account(
        id: json['id'] as String,
        number: json['number'] as String,
        currency: json['currency'] as String,
        balance: (json['balance'] as num).toDouble(),
        isActive: json['isActive'] as bool,
      );
}