// This is a basic Flutter widget test.

import 'package:flutter_test/flutter_test.dart';

import 'package:work/main.dart';

void main() {
  testWidgets('MainApp displays Hello World', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
  });
}
