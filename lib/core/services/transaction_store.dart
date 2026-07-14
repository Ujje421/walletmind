import 'dart:collection';
import 'package:flutter/foundation.dart';
import '../models/transaction_model.dart';
import '../constants/categories.dart';

/// In-memory transaction store for Phase 1-2.
/// Will be replaced with Isar in a later phase.
class TransactionStore extends ChangeNotifier {
  final List<Transaction> _transactions = [];

  /// All transactions, sorted newest first.
  UnmodifiableListView<Transaction> get transactions =>
      UnmodifiableListView(
        List.of(_transactions)..sort((a, b) => b.date.compareTo(a.date)),
      );

  /// Add a new transaction.
  void add(Transaction txn) {
    _transactions.add(txn);
    notifyListeners();
  }

  /// Update an existing transaction.
  void update(Transaction txn) {
    final idx = _transactions.indexWhere((t) => t.id == txn.id);
    if (idx != -1) {
      _transactions[idx] = txn;
      notifyListeners();
    }
  }

  /// Delete a transaction by ID.
  void delete(String id) {
    _transactions.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  /// Get recent transactions (limited count).
  List<Transaction> recent([int count = 10]) {
    return transactions.take(count).toList();
  }

  /// Total income for a date range.
  double totalIncome({DateTime? from, DateTime? to}) {
    return _filtered(from, to)
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  /// Total expenses for a date range.
  double totalExpenses({DateTime? from, DateTime? to}) {
    return _filtered(from, to)
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  /// Net balance (income - expenses).
  double balance({DateTime? from, DateTime? to}) {
    return totalIncome(from: from, to: to) - totalExpenses(from: from, to: to);
  }

  /// Expenses grouped by category.
  Map<TransactionCategory, double> expensesByCategory({
    DateTime? from,
    DateTime? to,
  }) {
    final map = <TransactionCategory, double>{};
    for (final t in _filtered(from, to)) {
      if (t.type == TransactionType.expense) {
        map[t.category] = (map[t.category] ?? 0) + t.amount;
      }
    }
    return map;
  }

  /// Monthly totals for chart data.
  List<MonthlyTotal> monthlyTotals({int months = 6}) {
    final now = DateTime.now();
    final result = <MonthlyTotal>[];

    for (int i = months - 1; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      final nextMonth = DateTime(month.year, month.month + 1, 1);

      final income = totalIncome(from: month, to: nextMonth);
      final expenses = totalExpenses(from: month, to: nextMonth);

      result.add(MonthlyTotal(month: month, income: income, expenses: expenses));
    }
    return result;
  }

  /// This month's range.
  ({DateTime start, DateTime end}) get thisMonthRange {
    final now = DateTime.now();
    return (
      start: DateTime(now.year, now.month, 1),
      end: DateTime(now.year, now.month + 1, 1),
    );
  }

  /// Last month's range.
  ({DateTime start, DateTime end}) get lastMonthRange {
    final now = DateTime.now();
    return (
      start: DateTime(now.year, now.month - 1, 1),
      end: DateTime(now.year, now.month, 1),
    );
  }

  // ─── Helpers ─────────────────────────────────────────────────────

  Iterable<Transaction> _filtered(DateTime? from, DateTime? to) {
    return _transactions.where((t) {
      if (from != null && t.date.isBefore(from)) return false;
      if (to != null && !t.date.isBefore(to)) return false;
      return true;
    });
  }
}

/// Monthly aggregated totals for charts.
class MonthlyTotal {
  final DateTime month;
  final double income;
  final double expenses;

  const MonthlyTotal({
    required this.month,
    required this.income,
    required this.expenses,
  });
}
