// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:delivery_app/main.dart';
import 'package:delivery_app/providers/auth_provider.dart';

void main() {
  testWidgets('App loads login screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => AuthProvider(),
        child: const DeliveryApp(),
      ),
    );

    // Verify that login screen loads
    expect(find.text('Welcome Back!'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
  });
}
