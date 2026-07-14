import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

/// Account / Settings screen.
class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // ─── Header ──────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Container(
            decoration: const BoxDecoration(
              gradient: AppColors.headerGradient,
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                child: Column(
                  children: [
                    const Text(
                      'Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Avatar
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.4),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Finance User',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Personal Account',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // ─── Settings Sections ───────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection(context, 'General', [
                  _SettingItem(Icons.currency_rupee_rounded, 'Currency', 'INR (₹)', AppColors.primaryPurple),
                  _SettingItem(Icons.language_rounded, 'Language', 'English', AppColors.categoryTransport),
                  _SettingItem(Icons.palette_rounded, 'Appearance', 'Light', AppColors.categoryEntertainment),
                  _SettingItem(Icons.notifications_rounded, 'Notifications', '', AppColors.categoryFood),
                ]),
                const SizedBox(height: 20),
                _buildSection(context, 'Security', [
                  _SettingItem(Icons.fingerprint_rounded, 'Biometric Lock', '', AppColors.income),
                  _SettingItem(Icons.pin_rounded, 'PIN Lock', '', AppColors.categoryInvestment),
                  _SettingItem(Icons.lock_rounded, 'App Lock', 'Off', AppColors.expense),
                ]),
                const SizedBox(height: 20),
                _buildSection(context, 'Data', [
                  _SettingItem(Icons.download_rounded, 'Export Data', '', AppColors.categoryTravel),
                  _SettingItem(Icons.upload_rounded, 'Import Data', '', AppColors.categoryEducation),
                  _SettingItem(Icons.delete_outline_rounded, 'Clear All Data', '', AppColors.expense),
                ]),
                const SizedBox(height: 20),
                _buildSection(context, 'About', [
                  _SettingItem(Icons.info_outline_rounded, 'About', 'v1.0.0', AppColors.textSecondary),
                  _SettingItem(Icons.privacy_tip_outlined, 'Privacy Policy', '', AppColors.textSecondary),
                  _SettingItem(Icons.description_outlined, 'Terms of Service', '', AppColors.textSecondary),
                ]),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(BuildContext context, String title, List<_SettingItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.textTertiary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceWhite,
            borderRadius: BorderRadius.circular(AppTheme.radiusL),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final idx = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  _buildSettingTile(context, item),
                  if (idx < items.length - 1)
                    const Divider(height: 0, indent: 56),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingTile(BuildContext context, _SettingItem item) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(AppTheme.radiusM),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: item.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(item.icon, color: item.color, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.label,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            if (item.value.isNotEmpty)
              Text(
                item.value,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary, size: 20),
          ],
        ),
      ),
    );
  }
}

class _SettingItem {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _SettingItem(this.icon, this.label, this.value, this.color);
}
