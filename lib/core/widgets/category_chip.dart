import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../constants/categories.dart';

/// Category chip — circular icon with label, matching the reference UI.
class CategoryChip extends StatelessWidget {
  final TransactionCategory category;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    required this.category,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isSelected
                  ? category.color
                  : category.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusL),
              border: isSelected
                  ? null
                  : Border.all(color: AppColors.borderLight),
            ),
            child: Icon(
              category.icon,
              color: isSelected ? Colors.white : category.color,
              size: AppTheme.iconL,
            ),
          ),
          const SizedBox(height: AppTheme.spacing6),
          SizedBox(
            width: 72,
            child: Text(
              category.label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: isSelected ? category.color : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
