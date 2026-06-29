import 'package:app/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app shell can be created', (WidgetTester tester) async {
    await tester.pumpWidget(const CallLogesApp());
  });
}
