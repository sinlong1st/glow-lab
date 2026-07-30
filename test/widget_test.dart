import 'package:flutter_test/flutter_test.dart';
import 'package:glow_lab/main.dart';

void main() {
  testWidgets('App boots to the home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const GlowLabApp());
    await tester.pump();
    expect(find.text('Open Studio'), findsOneWidget);
  });
}
