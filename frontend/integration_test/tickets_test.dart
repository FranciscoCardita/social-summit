import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:proj/main.dart' as app;


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Tickets', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Login to test account
    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('login_email_field')), 'test@dummy.com');
    await tester.enterText(find.byKey(const Key('login_password_field')), 'test123');

    await tester.tap(find.byKey(const Key('login_submit_button')));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.byKey(const Key('walletTitle')), findsOneWidget);

    // Tickets
    await tester.tap(find.byIcon(Icons.qr_code));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.byKey(const Key('ticketsTitle')), findsOneWidget);
    
    // See ticket details
    await tester.tap(find.byKey(const Key('tickets_ticket_0')));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.byKey(const Key('tickets_ticket_name')), findsOneWidget);

    await tester.tap(find.byKey(const Key('tickets_ticket_name_ok_button')));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.byKey(const Key('ticketsTitle')), findsOneWidget);

    // See ticket lineup
    await tester.tap(find.byKey(const Key('tickets_ticket_lineup_0')));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await Future.delayed(const Duration(seconds: 4));

    expect(find.byKey(const Key('tickets_ticket_lineup')), findsOneWidget);

    await tester.tap(find.byKey(const Key('tickets_ticket_lineup_ok_button')));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.byKey(const Key('ticketsTitle')), findsOneWidget);    
  });
  
}