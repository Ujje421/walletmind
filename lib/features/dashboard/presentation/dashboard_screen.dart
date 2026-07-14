import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/currencies.dart';

import '../../../core/services/transaction_store.dart';
import '../../../core/widgets/gradient_header.dart';
import '../../../core/widgets/transaction_tile.dart';

/// Dashboard / Home screen matching the reference UI.
class DashboardScreen extends StatelessWidget {
  final TransactionStore store;

  const DashboardScreen({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final range = store.thisMonthRange;
        final lastRange = store.lastMonthRange;
        final thisMonthExpenses = store.totalExpenses(
          from: range.start, to: range.end,
        );
        final lastMonthExpenses = store.totalExpenses(
          from: lastRange.start, to: lastRange.end,
        );
        final thisMonthIncome = store.totalIncome(
          from: range.start, to: range.end,
        );
        final recentTxns = store.recent(10);
        final balance = thisMonthIncome - thisMonthExpenses;

        // Calculate percentage change
        String changeText = '';
        if (lastMonthExpenses > 0) {
          final change = ((thisMonthExpenses - lastMonthExpenses) / lastMonthExpenses * 100).abs();
          final direction = thisMonthExpenses <= lastMonthExpenses ? 'below' : 'above';
          changeText = '↓ ${change.toStringAsFixed(0)}% $direction last month';
        }

        return CustomScrollView(
          slivers: [
            // ─── Gradient Header ─────────────────────────────────────
            SliverToBoxAdapter(
              child: GradientHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppTheme.spacing8),
                    // Top row: Settings, Date, Notifications
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(AppTheme.radiusM),
                          ),
                          child: const Icon(
                            Icons.settings_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacing12,
                            vertical: AppTheme.spacing6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(AppTheme.radiusRound),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.calendar_today_rounded,
                                  color: Colors.white, size: 14),
                              const SizedBox(width: 6),
                              Text(
                                DateFormat('EEE, d MMM').format(DateTime.now()),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(AppTheme.radiusM),
                          ),
                          child: const Icon(
                            Icons.notifications_none_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacing24),

                    // This Month Spend label
                    Text(
                      'This Month Spend',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing4),

                    // Large Amount
                    Text(
                      Currency.defaultCurrency.format(thisMonthExpenses),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -1,
                      ),
                    ),

                    if (changeText.isNotEmpty) ...[
                      const SizedBox(height: AppTheme.spacing4),
                      Text(
                        changeText,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // ─── Balance Card ────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing16,
                    vertical: AppTheme.spacing12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWhite,
                    borderRadius: BorderRadius.circular(AppTheme.radiusL),
                    border: Border.all(color: AppColors.borderLight),
                    boxShadow: AppTheme.cardShadow,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.primaryPurple.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppTheme.radiusS),
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet_rounded,
                          color: AppColors.primaryPurple,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacing12),
                      Text(
                        'Balance',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const Spacer(),
                      Text(
                        Currency.defaultCurrency.format(balance.abs()),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.textTertiary,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ─── Recent Transactions Header ──────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Transactions',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'See All',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.primaryPurple,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ─── Transaction List ────────────────────────────────────
            if (recentTxns.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Icon(
                        Icons.chat_bubble_outline_rounded,
                        size: 64,
                        color: AppColors.primaryPurple.withValues(alpha: 0.3),
                      ),
                      const SizedBox(height: AppTheme.spacing16),
                      Text(
                        'No transactions yet',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing8),
                      Text(
                        'Tap the chat button and type something like\n"Coffee 200" to get started!',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final txn = recentTxns[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: index < recentTxns.length - 1
                          ? const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: AppColors.divider,
                                  width: 1,
                                ),
                              ),
                            )
                          : null,
                      child: TransactionTile(transaction: txn),
                    );
                  },
                  childCount: recentTxns.length,
                ),
              ),

            // Bottom spacing for FAB
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        );
      },
    );
  }
}
