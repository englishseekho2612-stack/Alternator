import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:apps_alternator/main.dart' as app;

void main() {
  // Ensure the Integration test engine is fully bound to the target emulator/device.
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Apps Alternator End-to-End Integration Tests', () {
    testWidgets('Launches app, handles initial splash and checks dashboard accessibility', (WidgetTester tester) async {
      // 1. Initialize and render the actual production Flutter application
      app.main();
      await tester.pumpAndSettle();

      // 2. Verify that critical UI containers and typography are rendered on the screen
      expect(find.text('Apps Alternator'), findsWidgets);

      // 3. Future automated integration pipeline tests can simulate user typing and search:
      // - tester.enterText(find.byType(TextField), 'Figma');
      // - tester.tap(find.byType(IconButton).first);
      // - tester.pumpAndSettle();
      // - expect(find.text('Penpot'), findsOneWidget);
    });
  });
}
