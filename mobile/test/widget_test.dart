import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movetrack/src/app.dart';

void main() {
  testWidgets('MoveTrack app boots and shows splash', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MoveTrackApp()));

    expect(find.text('MoveTrack'), findsOneWidget);
    expect(find.text('Train better. Track smarter.'), findsOneWidget);

    // Splash screen schedules a 3s delayed navigation. Advance fake time to clear timer.
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
  });
}
