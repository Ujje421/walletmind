/// Supported currencies with symbols and formatting rules.
enum Currency {
  inr(code: 'INR', symbol: '₹', name: 'Indian Rupee', locale: 'en_IN'),
  usd(code: 'USD', symbol: '\$', name: 'US Dollar', locale: 'en_US'),
  eur(code: 'EUR', symbol: '€', name: 'Euro', locale: 'de_DE'),
  gbp(code: 'GBP', symbol: '£', name: 'British Pound', locale: 'en_GB'),
  jpy(code: 'JPY', symbol: '¥', name: 'Japanese Yen', locale: 'ja_JP'),
  aud(code: 'AUD', symbol: 'A\$', name: 'Australian Dollar', locale: 'en_AU'),
  cad(code: 'CAD', symbol: 'C\$', name: 'Canadian Dollar', locale: 'en_CA'),
  sgd(code: 'SGD', symbol: 'S\$', name: 'Singapore Dollar', locale: 'en_SG'),
  aed(code: 'AED', symbol: 'د.إ', name: 'UAE Dirham', locale: 'ar_AE');

  const Currency({
    required this.code,
    required this.symbol,
    required this.name,
    required this.locale,
  });

  final String code;
  final String symbol;
  final String name;
  final String locale;

  /// Default currency
  static const Currency defaultCurrency = Currency.inr;

  /// Format amount with currency symbol
  String format(double amount) {
    final isWholeNumber = amount == amount.roundToDouble();
    if (isWholeNumber) {
      return '$symbol${amount.toInt().toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]},',
      )}';
    }
    return '$symbol${amount.toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    )}';
  }
}
