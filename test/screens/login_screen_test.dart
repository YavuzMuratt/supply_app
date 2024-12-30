import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../lib/screens/login_screen.dart';

void main() {
  testWidgets('LoginScreen has email and password fields with login button',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: LoginScreen()));

        // Kontrolleri bul
        final emailField = find.byType(TextField).first;
        final passwordField = find.byType(TextField).last;
        final loginButton = find.widgetWithText(ElevatedButton, 'Login');

        // Kontrolleri doğrula
        expect(emailField, findsOneWidget);
        expect(passwordField, findsOneWidget);
        expect(loginButton, findsOneWidget);

        // Giriş alanlarına veri gir
        await tester.enterText(emailField, 'test@example.com');
        await tester.enterText(passwordField, '123456');

        // Login butonuna tıkla
        await tester.tap(loginButton);
        await tester.pump();

        // Test geçişi (simüle etmek için buraya bir doğrulama eklenebilir)
        expect(find.text('Login'), findsOneWidget);
      });
}
