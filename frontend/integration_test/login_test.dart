import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:proj/main.dart' as app;


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Login', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('login_email_field')), 'test@dummy.com');
    await tester.enterText(find.byKey(const Key('login_password_field')), 'test123');

    await tester.tap(find.byKey(const Key('login_submit_button')));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.byKey(const Key('walletTitle')), findsOneWidget);
  });
  
}