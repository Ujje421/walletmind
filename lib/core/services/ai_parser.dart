import 'package:uuid/uuid.dart';
import '../constants/categories.dart';
import '../constants/currencies.dart';
import '../models/transaction_model.dart';

/// Result of AI parsing a natural language input.
class ParsedTransaction {
  final double amount;
  final TransactionType type;
  final TransactionCategory category;
  final String? merchant;
  final DateTime date;
  final PaymentMethod paymentMethod;
  final String? notes;
  final double confidence;
  final String rawInput;

  const ParsedTransaction({
    required this.amount,
    required this.type,
    required this.category,
    this.merchant,
    required this.date,
    this.paymentMethod = PaymentMethod.cash,
    this.notes,
    required this.confidence,
    required this.rawInput,
  });

  /// Convert to a full Transaction.
  Transaction toTransaction() {
    final now = DateTime.now();
    return Transaction(
      id: const Uuid().v4(),
      amount: amount,
      type: type,
      category: category,
      merchant: merchant,
      date: date,
      paymentMethod: paymentMethod,
      notes: notes ?? rawInput,
      confidence: confidence,
      currency: Currency.defaultCurrency,
      createdAt: now,
      updatedAt: now,
    );
  }
}

/// AI-powered natural language parser for financial transactions.
///
/// Handles patterns like:
/// - "Coffee 200"
/// - "Salary credited 65000"
/// - "Paid rent 15000"
/// - "Dad gave me 5000"
/// - "Spent 500 on Uber"
/// - "UPI to Swiggy 420"
/// - "Petrol yesterday 1000"
class AiTransactionParser {
  static const _incomeKeywords = [
    'salary', 'credited', 'received', 'income', 'earned', 'got',
    'gave me', 'sent me', 'transferred to me', 'refund', 'cashback',
    'bonus', 'dividend', 'interest', 'freelance payment', 'payment received',
    'reimbursement', 'stipend', 'profit', 'return', 'paycheck',
  ];

  static const _paymentMethodKeywords = {
    'upi': PaymentMethod.upi,
    'gpay': PaymentMethod.upi,
    'google pay': PaymentMethod.upi,
    'phonepe': PaymentMethod.upi,
    'paytm': PaymentMethod.upi,
    'credit card': PaymentMethod.creditCard,
    'cc': PaymentMethod.creditCard,
    'debit card': PaymentMethod.debitCard,
    'dc': PaymentMethod.debitCard,
    'cash': PaymentMethod.cash,
    'bank transfer': PaymentMethod.bankTransfer,
    'neft': PaymentMethod.bankTransfer,
    'imps': PaymentMethod.bankTransfer,
    'rtgs': PaymentMethod.bankTransfer,
    'wallet': PaymentMethod.wallet,
  };

  /// Parse natural language into a structured transaction.
  /// Returns null if no amount is found.
  static ParsedTransaction? parse(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return null;

    // Extract amount
    final amount = _extractAmount(trimmed);
    if (amount == null) return null;

    // Determine type (income vs expense)
    final type = _detectType(trimmed);

    // Extract date
    final date = _extractDate(trimmed);

    // Detect payment method
    final paymentMethod = _detectPaymentMethod(trimmed);

    // Classify category
    final category = TransactionCategory.classify(trimmed);

    // Extract merchant (the non-amount, non-keyword text)
    final merchant = _extractMerchant(trimmed);

    // Calculate confidence
    final confidence = _calculateConfidence(
      amount: amount,
      type: type,
      category: category,
      merchant: merchant,
      input: trimmed,
    );

    return ParsedTransaction(
      amount: amount,
      type: type,
      category: category,
      merchant: merchant,
      date: date,
      paymentMethod: paymentMethod,
      notes: trimmed,
      confidence: confidence,
      rawInput: trimmed,
    );
  }

  /// Extract the numeric amount from text.
  static double? _extractAmount(String text) {
    // Remove currency symbols
    final cleaned = text
        .replaceAll('₹', '')
        .replaceAll('\$', '')
        .replaceAll('€', '')
        .replaceAll('£', '')
        .replaceAll(',', '');

    // Match numbers (including decimals), try the largest number found
    final matches = RegExp(r'\b(\d+\.?\d*)\b').allMatches(cleaned);
    if (matches.isEmpty) return null;

    // Use the largest number as the amount (heuristic: the amount is usually
    // the largest number in casual transaction text)
    double? largest;
    for (final m in matches) {
      final val = double.tryParse(m.group(1)!);
      if (val != null && val > 0) {
        if (largest == null || val > largest) {
          largest = val;
        }
      }
    }
    return largest;
  }

  /// Detect whether this is income or expense.
  static TransactionType _detectType(String text) {
    final lower = text.toLowerCase();
    for (final keyword in _incomeKeywords) {
      if (lower.contains(keyword)) return TransactionType.income;
    }
    return TransactionType.expense;
  }

  /// Extract date from text.
  static DateTime _extractDate(String text) {
    final lower = text.toLowerCase();
    final now = DateTime.now();

    if (lower.contains('yesterday')) {
      return DateTime(now.year, now.month, now.day - 1);
    }
    if (lower.contains('tomorrow')) {
      return DateTime(now.year, now.month, now.day + 1);
    }
    if (lower.contains('day before yesterday') || lower.contains('day before')) {
      return DateTime(now.year, now.month, now.day - 2);
    }

    // Relative days: "2 days ago", "3 days back"
    final daysAgo = RegExp(r'(\d+)\s*days?\s*(?:ago|back)').firstMatch(lower);
    if (daysAgo != null) {
      final days = int.parse(daysAgo.group(1)!);
      return DateTime(now.year, now.month, now.day - days);
    }

    // Day names: "last Monday", "on Friday"
    final dayNames = {
      'monday': DateTime.monday,
      'tuesday': DateTime.tuesday,
      'wednesday': DateTime.wednesday,
      'thursday': DateTime.thursday,
      'friday': DateTime.friday,
      'saturday': DateTime.saturday,
      'sunday': DateTime.sunday,
    };
    for (final entry in dayNames.entries) {
      if (lower.contains('last ${entry.key}') || lower.contains('on ${entry.key}')) {
        var target = now.subtract(const Duration(days: 7));
        while (target.weekday != entry.value) {
          target = target.add(const Duration(days: 1));
        }
        return target;
      }
    }

    return DateTime(now.year, now.month, now.day);
  }

  /// Detect payment method from text.
  static PaymentMethod _detectPaymentMethod(String text) {
    final lower = text.toLowerCase();
    for (final entry in _paymentMethodKeywords.entries) {
      if (lower.contains(entry.key)) return entry.value;
    }
    return PaymentMethod.cash;
  }

  /// Extract merchant name from text.
  static String? _extractMerchant(String text) {
    // Remove amount
    var cleaned = text.replaceAll(RegExp(r'[₹\$€£,]'), '');
    cleaned = cleaned.replaceAll(RegExp(r'\b\d+\.?\d*\b'), '').trim();

    // Remove common filler words
    final fillers = [
      'spent', 'paid', 'bought', 'on', 'at', 'for', 'to', 'from',
      'with', 'via', 'by', 'using', 'today', 'yesterday', 'tomorrow',
      'credited', 'received', 'gave', 'sent', 'me', 'my', 'the', 'a',
      'an', 'of', 'in', 'rupees', 'rs', 'upi',
    ];
    final words = cleaned.split(RegExp(r'\s+'));
    final meaningful = words.where((w) =>
      w.isNotEmpty && !fillers.contains(w.toLowerCase())
    ).toList();

    if (meaningful.isEmpty) return null;

    // Capitalize first letter of each word
    return meaningful
        .map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase())
        .join(' ');
  }

  /// Calculate confidence score (0.0 to 1.0).
  static double _calculateConfidence({
    required double amount,
    required TransactionType type,
    required TransactionCategory category,
    required String? merchant,
    required String input,
  }) {
    double score = 0.5; // Base

    // Amount found → +0.2
    if (amount > 0) score += 0.2;

    // Category not "other" → +0.15
    if (category != TransactionCategory.other) score += 0.15;

    // Merchant extracted → +0.1
    if (merchant != null && merchant.isNotEmpty) score += 0.1;

    // Type explicitly detected (income keywords) → +0.05
    if (type == TransactionType.income) score += 0.05;

    return score.clamp(0.0, 1.0);
  }
}
