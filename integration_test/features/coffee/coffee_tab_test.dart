import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:integration_test/integration_test.dart';
import 'package:very_good_coffee_app/core/app/app.dart';
import 'package:very_good_coffee_app/core/injectors/injector.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('CoffeeTab Integration Tests', () {
    setUp(() async {
      await GetIt.I.reset();
      SharedPreferences.setMockInitialValues({});
      await Injector.inject(GetIt.I);
    });

    tearDown(() async {
      await GetIt.I.reset();
    });

    testWidgets('should complete entire coffee tab success flow', (
      tester,
    ) async {
      // Step 1: Launch app and verify initial loading state
      await tester.pumpWidget(const App());

      // Navigate to Coffee tab
      await tester.tap(find.text('Coffee'));
      await tester.pump();

      // Verify loading message is displayed initially
      expect(find.text('Your coffee is getting ready...'), findsOneWidget);

      // Step 2: Wait for coffee to load and verify coffee card is displayed
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify coffee card is displayed (CachedNetworkImage widget)
      expect(find.byType(CachedNetworkImage), findsOneWidget);

      // Verify buttons are displayed
      expect(find.text('New coffee'), findsOneWidget);
      expect(find.text('Add to favorites'), findsOneWidget);

      // Step 3: Fetch new coffee when "New coffee" button is tapped
      await tester.tap(find.text('New coffee'));
      await tester.pump();

      // Wait for new coffee to load
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify coffee card is still displayed (new coffee loaded)
      expect(find.byType(CachedNetworkImage), findsOneWidget);
      expect(find.text('New coffee'), findsOneWidget);

      // Step 4: Add coffee to favorites
      expect(find.text('Add to favorites'), findsOneWidget);

      await tester.tap(find.text('Add to favorites'));
      await tester.pumpAndSettle();

      // Verify button text changes to "Remove from favorites"
      expect(find.text('Remove from favorites'), findsOneWidget);
      expect(find.text('Add to favorites'), findsNothing);

      // Step 5: Remove coffee from favorites
      await tester.tap(find.text('Remove from favorites'));
      await tester.pumpAndSettle();

      // Verify button text changes back to "Add to favorites"
      expect(find.text('Add to favorites'), findsOneWidget);
      expect(find.text('Remove from favorites'), findsNothing);

      // Verify coffee card is still displayed after all operations
      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });
  });
}
