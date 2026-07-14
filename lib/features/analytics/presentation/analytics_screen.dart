import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/currencies.dart';
import '../../../core/services/transaction_store.dart';
import '../../../core/widgets/stat_card.dart';
import '../../../core/widgets/transaction_tile.dart';

/// Analytics screen with charts matching the reference UI.
class AnalyticsScreen extends StatefulWidget {
  final TransactionStore store;

  const AnalyticsScreen({super.key, required this.store});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String _period = 'Monthly';

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.store,
      builder: (context, _) {
        final range = widget.store.thisMonthRange;
        final income = widget.store.totalIncome(
          from: range.start, to: range.end,
        );
        final expenses = widget.store.totalExpenses(
          from: range.start, to: range.end,
        );
        final monthlyTotals = widget.store.monthlyTotals(months: 6);
        final recentTxns = widget.store.recent(20);

        return CustomScrollView(
          slivers: [
            // ─── Header ──────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.headerGradient,
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    child: Column(
                      children: [
                        const Text(
                          'Analytics',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Period Selector
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _periodChip('Weekly'),
                            const SizedBox(width: 8),
                            _periodChip('Monthly'),
                            const SizedBox(width: 8),
                            _periodChip('Yearly'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ─── Chart ───────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWhite,
                    borderRadius: BorderRadius.circular(AppTheme.radiusL),
                    border: Border.all(color: AppColors.borderLight),
                    boxShadow: AppTheme.cardShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Legend
                      Row(
                        children: [
                          _legendDot(AppColors.income, 'Income'),
                          const SizedBox(width: 16),
                          _legendDot(AppColors.primaryPurple, 'Expense'),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Bar Chart
                      SizedBox(
                        height: 200,
                        child: monthlyTotals.isEmpty
                            ? const Center(
                                child: Text(
                                  'Add transactions to see charts',
                                  style: TextStyle(
                                    color: AppColors.textTertiary,
                                    fontSize: 13,
                                  ),
                                ),
                              )
                            : BarChart(
                                BarChartData(
                                  alignment: BarChartAlignment.spaceAround,
                                  maxY: _calculateMaxY(monthlyTotals),
                                  barTouchData: BarTouchData(
                                    enabled: true,
                                    touchTooltipData: BarTouchTooltipData(
                                      tooltipRoundedRadius: 8,
                                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                        final amount = rod.toY;
                                        final label = rodIndex == 0 ? 'Income' : 'Expense';
                                        return BarTooltipItem(
                                          '$label\n${Currency.defaultCurrency.format(amount)}',
                                          const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  titlesData: FlTitlesData(
                                    show: true,
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          final idx = value.toInt();
                                          if (idx < 0 || idx >= monthlyTotals.length) {
                                            return const SizedBox.shrink();
                                          }
                                          return Padding(
                                            padding: const EdgeInsets.only(top: 8),
                                            child: Text(
                                              DateFormat('MMM').format(monthlyTotals[idx].month),
                                              style: const TextStyle(
                                                color: AppColors.textTertiary,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          );
                                        },
                                        reservedSize: 28,
                                      ),
                                    ),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 50,
                                        getTitlesWidget: (value, meta) {
                                          if (value == 0) return const SizedBox.shrink();
                                          return Text(
                                            Currency.defaultCurrency.symbol + value.compact,
                                            style: const TextStyle(
                                              color: AppColors.textTertiary,
                                              fontSize: 10,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    topTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    rightTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                  ),
                                  gridData: FlGridData(
                                    show: true,
                                    drawVerticalLine: false,
                                    getDrawingHorizontalLine: (value) => FlLine(
                                      color: AppColors.borderLight,
                                      strokeWidth: 1,
                                    ),
                                  ),
                                  borderData: FlBorderData(show: false),
                                  barGroups: _buildBarGroups(monthlyTotals),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ─── Summary Cards ───────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        icon: Icons.arrow_downward_rounded,
                        iconColor: AppColors.income,
                        label: 'Income',
                        value: Currency.defaultCurrency.format(income),
                        valueColor: AppColors.income,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatCard(
                        icon: Icons.arrow_upward_rounded,
                        iconColor: AppColors.expense,
                        label: 'Expenses',
                        value: Currency.defaultCurrency.format(expenses),
                        valueColor: AppColors.expense,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ─── History Header ──────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Text(
                  'History',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),

            // ─── Transaction History ─────────────────────────────────
            if (recentTxns.isEmpty)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(
                    child: Text(
                      'No transactions yet',
                      style: TextStyle(color: AppColors.textTertiary),
                    ),
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: index < recentTxns.length - 1
                          ? const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: AppColors.divider),
                              ),
                            )
                          : null,
                      child: TransactionTile(transaction: recentTxns[index]),
                    );
                  },
                  childCount: recentTxns.length,
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        );
      },
    );
  }

  Widget _periodChip(String label) {
    final isSelected = _period == label;
    return GestureDetector(
      onTap: () => setState(() => _period = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white
              : Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppTheme.radiusRound),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.primaryPurple : Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  List<BarChartGroupData> _buildBarGroups(List<MonthlyTotal> totals) {
    return totals.asMap().entries.map((entry) {
      final idx = entry.key;
      final data = entry.value;
      return BarChartGroupData(
        x: idx,
        barRods: [
          BarChartRodData(
            toY: data.income,
            color: AppColors.income,
            width: 12,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
          BarChartRodData(
            toY: data.expenses,
            color: AppColors.primaryPurple,
            width: 12,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
        barsSpace: 4,
      );
    }).toList();
  }

  double _calculateMaxY(List<MonthlyTotal> totals) {
    double max = 0;
    for (final t in totals) {
      if (t.income > max) max = t.income;
      if (t.expenses > max) max = t.expenses;
    }
    return max == 0 ? 1000 : max * 1.2;
  }
}

// Import compact extension
extension _DoubleCompact on double {
  String get compact {
    if (this >= 10000000) return '${(this / 10000000).toStringAsFixed(1)}Cr';
    if (this >= 100000) return '${(this / 100000).toStringAsFixed(1)}L';
    if (this >= 1000) return '${(this / 1000).toStringAsFixed(1)}K';
    return toStringAsFixed(0);
  }
}
