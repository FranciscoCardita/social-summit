import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:proj/main.dart' as app;


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Group', (WidgetTester tester) async {
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

    // Group add friends
    await tester.tap(find.byIcon(Icons.map));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.byKey(const Key('map_group_button')), findsOneWidget);

    await tester.tap(find.byKey(const Key('map_group_button')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('map_group_add_friends_button')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('map_group_add_friends_email_field')), 'jamal@test.com');
    await tester.tap(find.byKey(const Key('map_group_add_friends_add_button')));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.byKey(const Key('map_group_add_friends_button')), findsOneWidget);

    await tester.tap(find.byKey(const Key('map_group_close_button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('map_group_button')), findsOneWidget);

    // Remove friend from group
    await tester.tap(find.byKey(const Key('map_group_button')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('map_group_remove_friend_Jamal')));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.byKey(const Key('map_group_remove_friend_Jamal')), findsNothing);

    await tester.tap(find.byKey(const Key('map_group_close_button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('map_group_button')), findsOneWidget);
  });
  
}