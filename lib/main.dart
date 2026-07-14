import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'core/services/transaction_store.dart';
import 'core/models/transaction_model.dart';
import 'core/constants/categories.dart';
import 'core/constants/currencies.dart';
import 'app_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const FinanceAiApp());
}

class FinanceAiApp extends StatefulWidget {
  const FinanceAiApp({super.key});

  @override
  State<FinanceAiApp> createState() => _FinanceAiAppState();
}

class _FinanceAiAppState extends State<FinanceAiApp> {
  late final TransactionStore _store;

  @override
  void initState() {
    super.initState();
    _store = TransactionStore();
    _addSampleData();
  }

  @override
  void dispose() {
    _store.dispose();
    super.dispose();
  }

  void _addSampleData() {
    final now = DateTime.now();

    // (text, amount, isIncome, daysAgo)
    final samples = <(String, double, bool, int)>[
      ('Salary credited', 65000, true, 1),
      ('Starbucks Coffee', 350, false, 0),
      ('Swiggy lunch', 420, false, 1),
      ('Netflix subscription', 649, false, 2),
      ('Uber ride', 280, false, 3),
      ('Groceries from BigBasket', 2400, false, 4),
      ('Electricity bill', 1850, false, 5),
      ('Dad sent money', 5000, true, 6),
      ('Petrol', 1200, false, 7),
      ('Amazon shopping', 3500, false, 8),
      ('Gym membership', 2000, false, 10),
      ('Freelance payment received', 15000, true, 12),
      ('Movie tickets', 800, false, 14),
      ('Medicine for Mom', 450, false, 15),
      ('Internet bill', 999, false, 18),
      ('Zomato dinner', 680, false, 20),
      ('Train ticket', 900, false, 22),
      ('Rent paid', 15000, false, 25),
      ('Salary credited', 65000, true, 30),
      ('Spotify subscription', 119, false, 32),
      ('Coffee', 200, false, 35),
      ('Auto rickshaw', 150, false, 38),
      ('Groceries', 1800, false, 40),
      ('Electricity bill', 1650, false, 42),
      ('Rent paid', 15000, false, 55),
    ];

    for (final s in samples) {
      final text = s.$1;
      final amount = s.$2;
      final isIncome = s.$3;
      final daysAgo = s.$4;
      final date = DateTime(now.year, now.month, now.day - daysAgo);
      final category = TransactionCategory.classify(text);

      _store.add(Transaction(
        id: '${text.hashCode}_$daysAgo',
        amount: amount,
        type: isIncome ? TransactionType.income : TransactionType.expense,
        category: category,
        merchant: text,
        date: date,
        paymentMethod: PaymentMethod.cash,
        notes: text,
        confidence: 1.0,
        currency: Currency.defaultCurrency,
        createdAt: date,
        updatedAt: date,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: AppShell(store: _store),
    );
  }
}
