import 'package:flutter_test/flutter_test.dart';
import 'package:brainbits/main.dart';

void main() {
  testWidgets('Splash screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const BrainBitsApp());
    expect(find.byType(BrainBitsApp), findsOneWidget);
  });
}
