import 'package:flutter_test/flutter_test.dart';
import 'package:Engezha/app/app.dart';

void main() {
  testWidgets('EngezhaApp renders', (WidgetTester tester) async {
    await tester.pumpWidget(const EngezhaApp());

    expect(find.byType(EngezhaApp), findsOneWidget);
  });
}
