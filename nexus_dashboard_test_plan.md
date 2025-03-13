# Nexus Dashboard App Test Plan

This document outlines automated test cases for the Nexus Dashboard application that can be implemented for both web and Android platforms. These test cases are designed to verify the functionality described in the test results document.

## Testing Framework Recommendations

For implementing these tests, we recommend:

- **Flutter Integration Tests**: For UI testing across both web and Android
- **Flutter Driver**: For handling interactions and assertions
- **Mock HTTP Client**: For simulating API responses
- **Golden Tests**: For visual regression testing

## Test Cases

### 1. App Features

#### 1.1 Theme Color Change Test

**Description**: Verify that changing the color from the action bar updates the entire app's theme.

**Test Steps**:
1. Launch the app
2. Tap the palette icon in the action bar
3. Select a different color (e.g., red) from the color wheel
4. Tap "Apply"
5. Navigate to different screens (Home, Groups)

**Expected Results**:
- Color picker dialog opens when palette icon is tapped
- Selected color is applied to the app's theme
- Theme color change is reflected in all UI elements (cards, buttons, navigation)
- Theme change persists when navigating between screens

**Platform Considerations**:
- On web, ensure color picker works with mouse interactions
- On Android, ensure color picker works with touch interactions

#### 1.2 Bottom Navigation Bar Test

**Description**: Verify that the bottom navigation bar correctly switches between different screens.

**Test Steps**:
1. Launch the app (starts on Home screen)
2. Tap the "Groups" tab in the bottom navigation
3. Verify Groups screen is displayed
4. Tap the "Lights" tab
5. Verify Lights "Coming Soon" screen is displayed
6. Tap the "Home" tab
7. Verify Home screen is displayed

**Expected Results**:
- Navigation between tabs works correctly
- Selected tab is highlighted with the primary color
- Each tab displays the correct screen content
- State is maintained when switching between tabs

#### 1.3 UI Hide/Show on Scroll Test

**Description**: Verify that the action bar and bottom navigation bar hide/show appropriately when scrolling.

**Test Steps**:
1. Launch the app
2. On the Home screen, scroll down
3. Verify bottom navigation bar hides
4. Scroll up
5. Verify bottom navigation bar reappears
6. Navigate to Groups tab
7. Repeat scroll down/up test

**Expected Results**:
- Bottom navigation bar smoothly animates out of view when scrolling down
- Bottom navigation bar smoothly animates into view when scrolling up
- Behavior is consistent across different screens

**Platform Considerations**:
- On web, test with both mouse wheel and trackpad scrolling
- On Android, test with touch scrolling

#### 1.4 Group Update/Delete Redirection Test

**Description**: Verify that the user is redirected to the group list page with updated list after group update/delete.

**Test Steps**:
1. Navigate to Groups tab
2. Tap on a group to view details
3. Edit the group description
4. Tap "Save Changes"
5. Verify redirection to Groups list
6. Verify updated description is visible in the list

**Expected Results**:
- User is redirected to the group list page after saving changes
- Updated group information is immediately visible in the list
- Group list is automatically refreshed to show the latest data

### 2. Home Screen Tests

#### 2.1 Group Fetching and Power State Display Test

**Description**: Verify that the home screen fetches all groups and correctly displays their power states.

**Test Steps**:
1. Launch the app
2. Observe the home screen

**Expected Results**:
- All groups are loaded and displayed
- Each group's power state is clearly indicated
- Powered-on groups have a different color than powered-off groups
- UI adapts to different screen sizes

**Platform Considerations**:
- Test on different screen sizes for both web and Android

#### 2.2 Power Toggle Functionality Test

**Description**: Verify that the power button correctly toggles power for all lights in a group.

**Test Steps**:
1. Launch the app
2. Identify a group that is powered off
3. Tap the power button for that group
4. Observe the UI update

**Expected Results**:
- API call is made to toggle the power state
- UI immediately updates to show the group as powered on
- Card color changes to match other powered-on groups

#### 2.3 Color Selector Test

**Description**: Verify that the color selector correctly changes the color of lights in a group.

**Test Steps**:
1. Launch the app
2. Tap the color picker button for a powered-on group
3. Select a color from the color wheel
4. Tap "Apply"

**Expected Results**:
- Color picker dialog opens
- Selected color can be applied
- API call is made to change the light color
- UI updates to reflect the change

#### 2.4 White Light Selector Test

**Description**: Verify that the white light selector correctly adjusts warm and cold white intensities.

**Test Steps**:
1. Launch the app
2. Tap the white light button for a powered-on group
3. Adjust the warm white slider
4. Tap "Apply Warm"
5. Reopen the white light controls
6. Adjust the cold white slider
7. Tap "Apply Cold"

**Expected Results**:
- White light controls dialog opens
- Sliders for both warm and cold white are displayed
- Settings can be applied separately
- API calls are made with correct parameters
- UI updates to reflect the changes

#### 2.5 UI Responsiveness Test

**Description**: Verify that the UI adapts correctly to different screen sizes.

**Test Steps**:
1. Launch the app on different screen sizes
2. Observe the home screen layout

**Expected Results**:
- Grid layout adjusts based on screen width
- UI elements scale appropriately
- Text remains readable
- Consistent look and feel across different screen sizes

**Platform Considerations**:
- On web, test with different browser window sizes
- On Android, test on different device sizes and orientations

### 3. Group Management Tests

#### 3.1 Group Fetching Test

**Description**: Verify that the Groups page fetches and displays all groups with their details.

**Test Steps**:
1. Navigate to the Groups tab
2. Observe the groups list

**Expected Results**:
- All groups are loaded and displayed
- Each group shows name, description, ID, and number of bulbs
- List is scrollable and maintains proper layout

#### 3.2 Create Group Navigation Test

**Description**: Verify that the create group button navigates to the group creation page.

**Test Steps**:
1. Navigate to the Groups tab
2. Tap the floating action button (+ icon)

**Expected Results**:
- Navigation to group creation page occurs
- Group creation form is displayed
- Form is initialized with a new ID

### 4. Group Details Tests

#### 4.1 Group Details Loading Test

**Description**: Verify that the Group Details page fetches and displays group details correctly.

**Test Steps**:
1. Navigate to the Groups tab
2. Tap on a group to view details

**Expected Results**:
- Group details are loaded from the API
- Form fields are populated with the group's data (ID, name, description)
- Loading indicators are displayed during data fetching

#### 4.2 Light Display Test

**Description**: Verify that the Group Details page correctly displays lights in the group and ungrouped lights.

**Test Steps**:
1. Navigate to the Groups tab
2. Tap on a group to view details
3. Observe the lights sections

**Expected Results**:
- Lights in the group are displayed in the "Lights in this Group" section
- Ungrouped lights are displayed in the "Ungrouped Lights" section (or appropriate message if none)
- Each light shows name, IP address, and power state

#### 4.3 Drag and Drop - Adding Lights Test

**Description**: Verify that drag and drop from ungrouped to grouped list correctly adds lights to the group.

**Test Steps**:
1. Navigate to the Groups tab
2. Tap on a group to view details
3. Drag a light from the ungrouped list to the grouped list

**Expected Results**:
- Light can be dragged from ungrouped to grouped list
- API call is made to add the light to the group
- UI updates to show the light in the grouped list

**Platform Considerations**:
- On web, test with mouse drag and drop
- On Android, test with touch drag and drop

#### 4.4 Drag and Drop - Removing Lights Test

**Description**: Verify that drag and drop from grouped to ungrouped list correctly removes lights from the group.

**Test Steps**:
1. Navigate to the Groups tab
2. Tap on a group to view details
3. Drag a light from the grouped list to the ungrouped list

**Expected Results**:
- Light can be dragged from grouped to ungrouped list
- API call is made to remove the light from the group
- UI updates to show the light in the ungrouped list

**Platform Considerations**:
- On web, test with mouse drag and drop
- On Android, test with touch drag and drop

#### 4.5 Group Editing Test

**Description**: Verify that editing group details works correctly.

**Test Steps**:
1. Navigate to the Groups tab
2. Tap on a group to view details
3. Edit the group name and description
4. Tap "Save Changes"

**Expected Results**:
- Form validates input correctly
- API call is made to update the group
- User is redirected to the group list
- Updated information is visible in the group list

## Implementation Guidelines

When implementing these test cases, consider the following:

1. **Setup and Teardown**:
   - Each test should start with a clean state
   - Mock API responses for predictable testing
   - Clean up any test data after tests complete

2. **Test Independence**:
   - Tests should be independent and not rely on the state from previous tests
   - Use appropriate test fixtures and mocks

3. **Cross-Platform Considerations**:
   - Use platform-agnostic selectors where possible
   - Handle platform-specific behaviors in separate helper methods
   - Test on multiple screen sizes for both platforms

4. **Error Handling**:
   - Include tests for error states and edge cases
   - Verify appropriate error messages are displayed

5. **Performance**:
   - Include timeouts for asynchronous operations
   - Consider adding performance benchmarks for critical operations

## Sample Test Implementation

Here's a sample of how the Theme Color Change test might be implemented using Flutter's integration testing framework:

```dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Theme Color Change Tests', () {
    testWidgets('Changing theme color updates the entire app', (WidgetTester tester) async {
      // Launch app
      app.main();
      await tester.pumpAndSettle();

      // Find and tap the palette icon
      final paletteIcon = find.byIcon(Icons.palette_outlined);
      await tester.tap(paletteIcon);
      await tester.pumpAndSettle();

      // Verify color picker dialog is shown
      expect(find.text('Choose a Theme Color'), findsOneWidget);

      // Select a red color (this would need to be adapted based on the actual color picker implementation)
      final redColorOption = find.byType(GestureDetector).at(3); // Assuming the 4th color is red
      await tester.tap(redColorOption);
      await tester.pumpAndSettle();

      // Tap Apply
      final applyButton = find.text('Apply');
      await tester.tap(applyButton);
      await tester.pumpAndSettle();

      // Verify theme color has changed (this would need to be adapted based on how to check theme colors)
      // One approach is to check a specific widget's color that should reflect the theme
      final themeColoredWidget = find.byType(AppBar);
      final appBarWidget = tester.widget<AppBar>(themeColoredWidget);
      expect(appBarWidget.backgroundColor, equals(Colors.red)); // Or whatever the expected color is

      // Navigate to Groups tab to verify theme persists
      final groupsTab = find.text('Groups');
      await tester.tap(groupsTab);
      await tester.pumpAndSettle();

      // Verify theme color persists on new screen
      final groupsAppBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(groupsAppBar.backgroundColor, equals(Colors.red));
    });
  });
}
```

## Conclusion

This test plan provides a comprehensive set of test cases for the Nexus Dashboard application. By implementing these tests using the recommended frameworks, you can ensure the application functions correctly across both web and Android platforms.

The test cases are designed to be:
- Clear and easy to understand
- Comprehensive in covering all key functionality
- Adaptable to both web and Android platforms
- Maintainable and extensible

When implementing these tests, focus on creating a robust test suite that can be run as part of your continuous integration pipeline to ensure ongoing quality of the application.