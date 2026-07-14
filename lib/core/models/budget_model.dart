import '../constants/categories.dart';

/// Budget model for tracking spending limits per category.
class Budget {
  final String id;
  final TransactionCategory category;
  final double limit;
  final double spent;
  final BudgetPeriod period;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;

  const Budget({
    required this.id,
    required this.category,
    required this.limit,
    this.spent = 0,
    this.period = BudgetPeriod.monthly,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
  });

  double get remaining => limit - spent;
  double get progress => limit > 0 ? (spent / limit).clamp(0.0, 1.0) : 0;
  bool get isOverBudget => spent > limit;
  double get percentUsed => (progress * 100);

  Budget copyWith({
    String? id,
    TransactionCategory? category,
    double? limit,
    double? spent,
    BudgetPeriod? period,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
  }) {
    return Budget(
      id: id ?? this.id,
      category: category ?? this.category,
      limit: limit ?? this.limit,
      spent: spent ?? this.spent,
      period: period ?? this.period,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

enum BudgetPeriod {
  weekly(label: 'Weekly'),
  monthly(label: 'Monthly'),
  yearly(label: 'Yearly');

  const BudgetPeriod({required this.label});
  final String label;
}
