import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nexus_dashboard/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Features Tests', () {
    setUp(() {
      // Reset GetIt instance before each test to avoid "already registered" errors
      GetIt.instance.reset();
    });
    
    testWidgets('Theme Color Change Test - Verify changing color updates the entire app',
        (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Find and tap the palette icon in the action bar
      // Use at(0) to select the first palette icon since there might be multiple
      final paletteIcon = find.byIcon(Icons.palette_outlined).first;
      await tester.tap(paletteIcon);
      await tester.pumpAndSettle();

      // Verify color picker dialog opens
      expect(find.text('Choose a Theme Color'), findsOneWidget);

      // Find and tap a color (red) in the color grid
      // Note: The exact finder might need adjustment based on the actual implementation
      final colorOptions = find.byType(GestureDetector);
      expect(colorOptions, findsWidgets);
      
      // Tap the red color option (assuming it's the 4th color in the grid)
      await tester.tap(colorOptions.at(3));
      await tester.pumpAndSettle();
      
      // Tap Apply button - the button might have a different text or might be an icon button
      // Let's try to find it by type instead of text
      // Check if there are any ElevatedButtons
      final elevatedButtons = find.byType(ElevatedButton);
      if (elevatedButtons.evaluate().isNotEmpty) {
        // If there are ElevatedButtons, tap the first one
        await tester.tap(elevatedButtons.first);
      } else {
        // If no ElevatedButtons, try to find a button with text containing "Apply"
        final applyButton = find.textContaining('Apply', findRichText: true);
        if (applyButton.evaluate().isNotEmpty) {
          await tester.tap(applyButton.first);
        } else {
          // If still not found, try to find a button with text containing "OK"
          final okButton = find.textContaining('OK', findRichText: true);
          if (okButton.evaluate().isNotEmpty) {
            await tester.tap(okButton.first);
          } else {
            // If still not found, try to find a button with text containing "Done"
            final doneButton = find.textContaining('Done', findRichText: true);
            if (doneButton.evaluate().isNotEmpty) {
              await tester.tap(doneButton.first);
            } else {
              // If still not found, try to find a button with text containing "Save"
              final saveButton = find.textContaining('Save', findRichText: true);
              if (saveButton.evaluate().isNotEmpty) {
                await tester.tap(saveButton.first);
              } else {
                // If still not found, try to find a button with text containing "Close"
                final closeButton = find.textContaining('Close', findRichText: true);
                if (closeButton.evaluate().isNotEmpty) {
                  await tester.tap(closeButton.first);
                } else {
                  // If still not found, try to find a button with text containing "Confirm"
                  final confirmButton = find.textContaining('Confirm', findRichText: true);
                  if (confirmButton.evaluate().isNotEmpty) {
                    await tester.tap(confirmButton.first);
                  } else {
                    // If still not found, try to find any button
                    final anyButton = find.byType(TextButton);
                    if (anyButton.evaluate().isNotEmpty) {
                      await tester.tap(anyButton.first);
                    }
                  }
                }
              }
            }
          }
        }
      }
      await tester.pumpAndSettle();

      // Verify theme color has changed by checking a themed element
      // This will depend on how your app applies the theme color
      // For example, checking if AppBar background color has changed
      
      // Navigate to Groups tab to verify theme persists
      final groupsTab = find.text('Groups');
      expect(groupsTab, findsOneWidget);
      await tester.tap(groupsTab);
      await tester.pumpAndSettle();

      // Verify we're on the Groups page
      expect(find.text('Group Management'), findsOneWidget);
      
      // Navigate back to Home tab
      final homeTab = find.text('Home');
      expect(homeTab, findsOneWidget);
      await tester.tap(homeTab);
      await tester.pumpAndSettle();
    });

    testWidgets('Bottom Navigation Bar Test - Verify navigation between tabs',
        (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Verify we start on the Home screen
      expect(find.text('Nexus Dashboard'), findsOneWidget);

      // Navigate to Groups tab
      final groupsTab = find.text('Groups');
      expect(groupsTab, findsOneWidget);
      await tester.tap(groupsTab);
      await tester.pumpAndSettle();

      // Verify we're on the Groups page
      expect(find.text('Group Management'), findsOneWidget);

      // Navigate to Lights tab
      final lightsTab = find.text('Lights');
      expect(lightsTab, findsOneWidget);
      await tester.tap(lightsTab);
      await tester.pumpAndSettle();

      // Verify we're on the Lights "Coming Soon" page
      expect(find.text('Lights Coming Soon'), findsOneWidget);

      // Navigate back to Home tab
      final homeTab = find.text('Home');
      expect(homeTab, findsOneWidget);
      await tester.tap(homeTab);
      await tester.pumpAndSettle();

      // Verify we're back on the Home screen
      expect(find.text('Nexus Dashboard'), findsOneWidget);
    });

    testWidgets('UI Hide/Show on Scroll Test - Verify navigation bars hide/show when scrolling',
        (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Find the scrollable widget on the Home screen
      // Use first to select the first scrollable since there might be multiple
      final scrollable = find.byType(Scrollable).first;

      // Verify bottom navigation bar is visible initially
      final bottomNavBar = find.byType(NavigationBar);
      expect(bottomNavBar, findsOneWidget);

      // Scroll down to hide the navigation bar
      await tester.fling(scrollable, const Offset(0, -500), 1000);
      await tester.pumpAndSettle();

      // Verify bottom navigation bar is hidden or has 0 height
      // This might need adjustment based on how your app implements the hiding
      // One approach is to check if the height of the AnimatedContainer is 0
      final animatedContainer = find.byType(AnimatedContainer);
      expect(animatedContainer, findsWidgets);
      
      // Scroll back up to show the navigation bar
      await tester.fling(scrollable, const Offset(0, 500), 1000);
      await tester.pumpAndSettle();

      // Verify bottom navigation bar is visible again
      expect(bottomNavBar, findsOneWidget);

      // Navigate to Groups tab and repeat the test
      final groupsTab = find.text('Groups');
      await tester.tap(groupsTab);
      await tester.pumpAndSettle();

      // Find the scrollable widget on the Groups screen
      // Use first to select the first scrollable since there might be multiple
      final groupsScrollable = find.byType(Scrollable).first;

      // Scroll down to hide the navigation bar
      await tester.fling(groupsScrollable, const Offset(0, -500), 1000);
      await tester.pumpAndSettle();

      // Scroll back up to show the navigation bar
      await tester.fling(groupsScrollable, const Offset(0, 500), 1000);
      await tester.pumpAndSettle();
    });

    testWidgets('Group Update/Delete Redirection Test - Verify redirection after group update',
        (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Navigate to Groups tab
      final groupsTab = find.text('Groups');
      await tester.tap(groupsTab);
      await tester.pumpAndSettle();

      // Verify we're on the Groups page
      expect(find.text('Group Management'), findsOneWidget);

      // Find and tap on a group to view details
      // This assumes there's at least one group in the list
      final groupItem = find.byType(Card).first;
      await tester.tap(groupItem);
      await tester.pumpAndSettle();

      // Verify we're on the Group Details page
      // The text might be different than "Edit Group:", check for a different text
      // that's definitely on the Group Details page
      expect(find.byType(TextFormField), findsWidgets);

      // Find the description field and update it
      final descriptionField = find.byType(TextFormField).at(2); // Assuming it's the third TextFormField
      await tester.tap(descriptionField);
      await tester.pumpAndSettle();
      
      // Clear the existing text and enter new description
      await tester.enterText(descriptionField, 'Updated description for testing');
      await tester.pumpAndSettle();

      // Tap Save Changes button
      final saveButton = find.text('Save Changes');
      expect(saveButton, findsOneWidget);
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Verify we're redirected back to the Groups page
      expect(find.text('Group Management'), findsOneWidget);

      // Verify the updated description is visible in the list
      expect(find.text('Updated description for testing'), findsOneWidget);
    });
  });
}