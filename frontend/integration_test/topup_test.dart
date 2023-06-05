import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:proj/main.dart' as app;


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Top Up', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Login to test account
    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('login_email_field')), 'test@dummy.com');
    await tester.enterText(find.byKey(const Key('login_password_field')), 'test123');

    await tester.tap(find.byKey(const Key('login_submit_button')));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.byKey(const Key('walletTitle')), findsOneWidget);

    // Top up - MB Way
    final balanceFinder = find.byKey(const Key('wallet_balance'));
    final balanceText = (tester.widget<Text>(balanceFinder)).data;
    final balance = double.parse(balanceText!.substring(0, balanceText.length - 2));

    await tester.tap(find.byKey(const Key('wallet_add_funds_button')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('wallet_mbway')));
    await tester.enterText(find.byKey(const Key('wallet_phone_field')), '123456789');
    await tester.enterText(find.byKey(const Key('wallet_amount_field')), '10');

    await tester.tap(find.byKey(const Key('wallet_confirm_button')));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.byKey(const Key('walletTitle')), findsOneWidget);
    
    final newBalanceFinder = find.byKey(const Key('wallet_balance'));
    final newBalanceText = (tester.widget<Text>(newBalanceFinder)).data;
    final newBalance = double.parse(newBalanceText!.substring(0, newBalanceText.length - 2));
    expect(newBalance, balance + 10);

    // Top up - Credit Card
    await tester.tap(find.byKey(const Key('wallet_add_funds_button')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('wallet_card')));
    await tester.enterText(find.byKey(const Key('wallet_card_field')), '123456789');
    await tester.enterText(find.byKey(const Key('wallet_expiry_field')), '10-23');
    await tester.enterText(find.byKey(const Key('wallet_security_field')), '123');
    await tester.enterText(find.byKey(const Key('wallet_amount_field')), '10');

    await tester.tap(find.byKey(const Key('wallet_confirm_button')));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.byKey(const Key('walletTitle')), findsOneWidget);

    final newBalanceFinder2 = find.byKey(const Key('wallet_balance'));
    final newBalanceText2 = (tester.widget<Text>(newBalanceFinder2)).data;
    final newBalance2 = double.parse(newBalanceText2!.substring(0, newBalanceText2.length - 2));
    expect(newBalance2, newBalance + 10);
  });
  
}