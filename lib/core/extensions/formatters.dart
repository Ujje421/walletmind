import 'package:intl/intl.dart';

/// Extension methods on DateTime for display formatting.
extension DateTimeFormatting on DateTime {
  /// "Today", "Yesterday", or "14 Jul 2026"
  String get displayDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(year, month, day);

    if (date == today) return 'Today';
    if (date == today.subtract(const Duration(days: 1))) return 'Yesterday';
    if (date == today.add(const Duration(days: 1))) return 'Tomorrow';

    if (date.year == today.year) {
      return DateFormat('d MMM').format(this);
    }
    return DateFormat('d MMM yyyy').format(this);
  }

  /// "Mon, 14 Jul"
  String get displayDateWithDay => DateFormat('EEE, d MMM').format(this);

  /// "July 2026"
  String get monthYear => DateFormat('MMMM yyyy').format(this);

  /// "Jul"
  String get shortMonth => DateFormat('MMM').format(this);

  /// "14 Jul 2026, 2:30 PM"
  String get displayFull => DateFormat('d MMM yyyy, h:mm a').format(this);

  /// "2:30 PM"
  String get displayTime => DateFormat('h:mm a').format(this);
}

/// Extension methods on double for financial formatting.
extension DoubleFormatting on double {
  /// Compact format: 1.2K, 45.3K, 1.5L, 2.3Cr
  String get compact {
    if (this >= 10000000) return '${(this / 10000000).toStringAsFixed(1)}Cr';
    if (this >= 100000) return '${(this / 100000).toStringAsFixed(1)}L';
    if (this >= 1000) return '${(this / 1000).toStringAsFixed(1)}K';
    return toStringAsFixed(0);
  }
}

/// Extension on String for title case.
extension StringCasing on String {
  String get titleCase {
    if (isEmpty) return this;
    return split(' ')
        .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}')
        .join(' ');
  }
}
