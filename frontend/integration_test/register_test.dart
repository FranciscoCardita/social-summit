import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:proj/main.dart' as app;


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Register', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('signup_button')));
    await tester.pumpAndSettle();

    // Name, email, phone, birthday, password, confirm password
    await tester.enterText(find.byKey(const Key('signup_name_field')), 'Test User ${DateTime.now().millisecondsSinceEpoch}');
    await tester.enterText(find.byKey(const Key('signup_email_field')), 'testuser${DateTime.now().millisecondsSinceEpoch}@test.com');
    await tester.enterText(find.byKey(const Key('signup_phone_field')), '123456789');
    await tester.enterText(find.byKey(const Key('signup_birthday_field')), '01/01/2000');
    await tester.enterText(find.byKey(const Key('signup_password_field')), 'test123');
    await tester.enterText(find.byKey(const Key('signup_confirm_password_field')), 'test123');

    await tester.tap(find.byKey(const Key('signup_submit_button')));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.byKey(const Key('walletTitle')), findsOneWidget);
  });
  
}