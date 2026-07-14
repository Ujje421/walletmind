import 'package:flutter/material.dart';
import '../constants/categories.dart';
import '../constants/currencies.dart';

/// The type of a financial transaction.
enum TransactionType { income, expense }

/// Payment method used for the transaction.
enum PaymentMethod {
  cash(label: 'Cash', icon: Icons.money_rounded),
  upi(label: 'UPI', icon: Icons.qr_code_rounded),
  creditCard(label: 'Credit Card', icon: Icons.credit_card_rounded),
  debitCard(label: 'Debit Card', icon: Icons.credit_card_rounded),
  bankTransfer(label: 'Bank Transfer', icon: Icons.account_balance_rounded),
  wallet(label: 'Wallet', icon: Icons.account_balance_wallet_rounded),
  other(label: 'Other', icon: Icons.more_horiz_rounded);

  const PaymentMethod({required this.label, required this.icon});
  final String label;
  final IconData icon;
}

/// Core transaction model. Immutable and used across the entire app.
class Transaction {
  final String id;
  final double amount;
  final TransactionType type;
  final TransactionCategory category;
  final String? merchant;
  final DateTime date;
  final PaymentMethod paymentMethod;
  final String? notes;
  final List<String> tags;
  final double confidence;
  final bool isRecurring;
  final Currency currency;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Transaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.category,
    this.merchant,
    required this.date,
    this.paymentMethod = PaymentMethod.cash,
    this.notes,
    this.tags = const [],
    this.confidence = 1.0,
    this.isRecurring = false,
    this.currency = Currency.inr,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create a copy with optional overrides.
  Transaction copyWith({
    String? id,
    double? amount,
    TransactionType? type,
    TransactionCategory? category,
    String? merchant,
    DateTime? date,
    PaymentMethod? paymentMethod,
    String? notes,
    List<String>? tags,
    double? confidence,
    bool? isRecurring,
    Currency? currency,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      merchant: merchant ?? this.merchant,
      date: date ?? this.date,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      notes: notes ?? this.notes,
      tags: tags ?? this.tags,
      confidence: confidence ?? this.confidence,
      isRecurring: isRecurring ?? this.isRecurring,
      currency: currency ?? this.currency,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  /// Formatted amount with currency symbol.
  String get formattedAmount => currency.format(amount);

  /// Display amount with +/- prefix.
  String get displayAmount {
    final prefix = type == TransactionType.income ? '+' : '-';
    return '$prefix${currency.format(amount)}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Transaction && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
