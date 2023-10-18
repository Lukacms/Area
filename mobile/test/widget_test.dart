// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/back/services.dart';

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
}

void main() {
  offlineTests();
}
