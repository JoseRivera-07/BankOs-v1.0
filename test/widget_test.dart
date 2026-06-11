import 'package:flutter_test/flutter_test.dart';
import 'package:bank_os/main.dart';

void main() {
  testWidgets('BankOS smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const BankOsApp());
    expect(find.byType(BankOsApp), findsOneWidget);
  });
}