import 'package:flutter_test/flutter_test.dart';
import 'package:finance_ai/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FinanceAiApp());

    // Verify that the dashboard loads
    expect(find.text('This Month Spend'), findsOneWidget);
  });
}
