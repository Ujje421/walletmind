/// Financial goal model for tracking savings targets.
class FinancialGoal {
  final String id;
  final String name;
  final String? emoji;
  final double targetAmount;
  final double savedAmount;
  final DateTime? deadline;
  final DateTime createdAt;

  const FinancialGoal({
    required this.id,
    required this.name,
    this.emoji,
    required this.targetAmount,
    this.savedAmount = 0,
    this.deadline,
    required this.createdAt,
  });

  double get progress =>
      targetAmount > 0 ? (savedAmount / targetAmount).clamp(0.0, 1.0) : 0;
  double get remaining => targetAmount - savedAmount;
  bool get isComplete => savedAmount >= targetAmount;
  double get percentComplete => progress * 100;
}
