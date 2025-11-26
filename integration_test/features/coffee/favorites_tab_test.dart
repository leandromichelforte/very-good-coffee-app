import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:integration_test/integration_test.dart';
import 'package:very_good_coffee_app/core/app/app.dart';
import 'package:very_good_coffee_app/core/injectors/injector.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('FavoritesTab Integration Tests', () {
    setUp(() async {
      await GetIt.I.reset();
      SharedPreferences.setMockInitialValues({});
      await Injector.inject(GetIt.I);
    });

    tearDown(() async {
      await GetIt.I.reset();
    });

    testWidgets('should complete entire favorites tab success flow', (
      tester,
    ) async {
      // Step 1: Launch app and verify empty favorites state
      await tester.pumpWidget(const App());

      // Navigate to Favorites tab
      await tester.tap(find.text('Favorites'));
      await tester.pump();

      // Wait for favorites to load
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify empty favorites message is displayed
      expect(find.text('Nothing here yet :('), findsOneWidget);
      expect(
        find.text('Go back to Coffee tab and get your favorite coffees'),
        findsOneWidget,
      );

      // Step 2: Navigate to Coffee tab and add a coffee to favorites
      await tester.tap(find.text('Coffee'));
      await tester.pump();

      // Wait for coffee to load
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify coffee is displayed
      expect(find.byType(CachedNetworkImage), findsOneWidget);
      expect(find.text('Add to favorites'), findsOneWidget);

      // Add coffee to favorites
      await tester.tap(find.text('Add to favorites'));
      await tester.pumpAndSettle();

      // Verify button changed to "Remove from favorites"
      expect(find.text('Remove from favorites'), findsOneWidget);

      // Step 3: Navigate back to Favorites tab and verify favorites list
      await tester.tap(find.text('Favorites'));
      await tester.pump();

      // Wait for favorites to load
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify favorites list is displayed with coffee card
      expect(find.byType(CachedNetworkImage), findsOneWidget);
      expect(find.text('Nothing here yet :('), findsNothing);

      // Step 4: Remove coffee from favorites using delete button
      final deleteButtons = find.byIcon(Icons.delete_rounded);
      expect(deleteButtons, findsOneWidget);

      await tester.tap(deleteButtons.first);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify the coffee was removed (empty message should appear)
      expect(find.text('Nothing here yet :('), findsOneWidget);
      expect(find.byType(CachedNetworkImage), findsNothing);

      // Step 5: Navigate back to Coffee tab and verify favorite status is synced
      await tester.tap(find.text('Coffee'));
      await tester.pumpAndSettle();

      // The button should show "Add to favorites" since it was removed
      // This verifies the syncIsFavorite functionality
      expect(find.text('Add to favorites'), findsOneWidget);
      expect(find.text('Remove from favorites'), findsNothing);
    });
  });
}
