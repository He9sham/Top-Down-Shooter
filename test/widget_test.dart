import 'package:flame/game.dart';
import 'package:flutter_games/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('GameApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const GameApp());

    // Verify that the GameWidget is present
    expect(find.byType(GameWidget), findsOneWidget);
  });
}
