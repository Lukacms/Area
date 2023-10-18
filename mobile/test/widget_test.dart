// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/back/services.dart';
import 'package:mobile/screens/login/forgot_password.dart';
import 'package:mobile/screens/login/login.dart';
import 'package:mobile/screens/register.dart';

bool isValidEmail(String email) {
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return emailRegex.hasMatch(email);
}

void offlineTests() {
  List<dynamic> actionListTest = [
    {
      'serviceId': 1,
      'id': 1,
      'name': 'Turn on',
      'endpoint': "Test endpoint",
      'defaultConfiguration': {
        'test': 'test',
      },
    },
  ];
  test('testing the parsing of actions as returned from the server', () {
    expect(AppServices().actionParse(actionListTest).first.name, 'Turn on');
  });
  List<dynamic> reactionListTest = [
    {
      'serviceId': 1,
      'id': 1,
      'name': 'Turn on',
      'endpoint': "Test endpoint",
      'defaultConfiguration': {
        'test': 'test',
      },
    },
  ];
  test('testing the parsing of reactions as returned from the server', () {
    expect(AppServices().actionParse(reactionListTest).first.name, 'Turn on');
  });
  List<dynamic> servicesListTest = [
    {
      'id': 1,
      'name': 'Test service',
      'connectionLink': "Test connection link",
      'endpoint': "Test endpoint",
      'svgIcon': "Test svg icon",
      'iconColor': "Test icon color",
      'category': "Test category",
    },
  ];
  test('testing the parsing of services as returned from the server', () {
    expect(AppServices().serviceParse(servicesListTest).first.name,
        'Test service');
  });
  test('testing the valid email checking function', () {
    expect(isValidEmail("okokokok"), false);
  });
  test('testing the valid email checking function', () {
    expect(isValidEmail("elliotjanvier@gmail.com"), true);
  });
}

void widgetTests() {
  testWidgets(
      'LoginWidget shows username and password fields and a login button',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(const MaterialApp(home: Scaffold(body: LoginScreen())));

    expect(find.byKey(const Key('usernameField')), findsOneWidget);
    expect(find.byKey(const Key('passwordField')), findsOneWidget);
    expect(find.byKey(const Key('loginButton')), findsOneWidget);
  });
  testWidgets('Forgot password displays email field and reset password button',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(const MaterialApp(home: Scaffold(body: ForgotPassword())));

    expect(find.byKey(const Key('emailField')), findsOneWidget);
    expect(find.byKey(const Key('resetPasswordButton')), findsOneWidget);
  });
  testWidgets(
      'Sign up screen displays name, surname, username, email, password fields and signup button',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(const MaterialApp(home: Scaffold(body: RegisterScreen())));

    expect(find.byKey(const Key('nameField')), findsOneWidget);
    expect(find.byKey(const Key('surnameField')), findsOneWidget);
    expect(find.byKey(const Key('usernameField')), findsOneWidget);
    expect(find.byKey(const Key('emailField')), findsOneWidget);
    expect(find.byKey(const Key('passwordField')), findsOneWidget);
    expect(find.byKey(const Key('signupButton')), findsOneWidget);
  });
}

void main() {
  offlineTests();
  widgetTests();
}
