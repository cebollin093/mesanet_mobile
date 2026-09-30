// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mesanet/main.dart';
import 'package:mesanet/screens/auth/login_screen.dart';

void main() {
  testWidgets('MesaNet inicia en la pantalla de login', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MesaNetApp());
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
  });
}
