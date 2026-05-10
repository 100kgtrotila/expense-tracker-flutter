import 'package:expense_tracker/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App renders without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('My Expenses'), findsOneWidget);
  });
}
