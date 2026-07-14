import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../extensions/formatters.dart';

/// A single transaction list item matching the reference UI.
/// Shows category icon, merchant/name, date, and amount.
class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;

  const TransactionTile({
    super.key,
    required this.transaction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isExpense = transaction.type == TransactionType.expense;
    final amountColor = isExpense ? AppColors.expense : AppColors.income;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusM),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacing16,
          vertical: AppTheme.spacing12,
        ),
        child: Row(
          children: [
            // Category Icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: transaction.category.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
              ),
              child: Icon(
                transaction.category.icon,
                color: transaction.category.color,
                size: AppTheme.iconL,
              ),
            ),
            const SizedBox(width: AppTheme.spacing12),

            // Name & Date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.merchant ??
                        transaction.category.label,
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    transaction.date.displayDate,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),

            // Amount & Arrow
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  transaction.displayAmount,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: amountColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: AppTheme.spacing4),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textTertiary,
                  size: AppTheme.iconM,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
