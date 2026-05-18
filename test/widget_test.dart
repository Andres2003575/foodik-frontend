import 'package:flutter_test/flutter_test.dart';
import 'package:foodik_frontend/main.dart';

void main() {
  testWidgets('Foodik smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FoodikApp());
  });
}