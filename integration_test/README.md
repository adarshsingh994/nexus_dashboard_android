# Nexus Dashboard Integration Tests

This directory contains integration tests for the Nexus Dashboard application. These tests are designed to run on both web and Android platforms.

## Test Structure

The tests are organized into the following files:

- `app_features_test.dart`: Tests for app-wide features like theme color change, bottom navigation, UI hide/show on scroll, and group update/delete redirection.
- `home_screen_test.dart`: Tests for the Home screen functionality including group fetching, power toggle, color and white selectors, and UI responsiveness.
- `group_management_test.dart`: Tests for the Group Management page including group fetching and create group navigation.
- `group_details_test.dart`: Tests for the Group Details page including group details loading, light display, drag and drop functionality, and group editing.
- `all_tests.dart`: A combined test file that runs all the tests together.

## Running the Tests

### Prerequisites

Make sure you have the following dependencies in your `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
  flutter_driver:
    sdk: flutter
  mockito: ^5.4.4
  bloc_test: ^9.1.6
  http_mock_adapter: ^0.6.1
```

Run `flutter pub get` to install the dependencies.

### Running on Android

1. Connect an Android device or start an emulator.
2. Run the following command from the project root:

```bash
flutter test integration_test/all_tests.dart
```

Or to run a specific test file:

```bash
flutter test integration_test/app_features_test.dart
```

### Running on Web

1. Make sure you have Chrome installed.
2. Run the following command from the project root:

```bash
flutter drive \
  --driver=test_driver/integration_test_driver.dart \
  --target=integration_test/all_tests.dart \
  -d chrome
```

Or to run a specific test file:

```bash
flutter drive \
  --driver=test_driver/integration_test_driver.dart \
  --target=integration_test/app_features_test.dart \
  -d chrome
```

## Test Considerations

### API Mocking

These tests assume that the API is available and returns expected responses. In a real-world scenario, you might want to mock the API responses to ensure consistent test results.

To mock API responses, you can use the `http_mock_adapter` package and set up mock responses for your API calls.

### Test Data

Some tests assume that there is existing data in the app (e.g., groups, lights). In a real-world scenario, you might want to set up test data before running the tests.

### Platform-Specific Behavior

Some tests might behave differently on web and Android due to platform-specific implementations. Make sure to test on both platforms to ensure your app works correctly on all supported platforms.

## Troubleshooting

### Tests Failing Due to UI Changes

If the tests are failing due to UI changes, you might need to update the finders in the test files. For example, if a button text has changed from "Save" to "Save Changes", you'll need to update the finder from `find.text('Save')` to `find.text('Save Changes')`.

### Tests Timing Out

If the tests are timing out, you might need to increase the timeout duration or optimize your app's performance. You can increase the timeout duration by setting the `timeout` parameter in the `testWidgets` function:

```dart
testWidgets('Test Description', (WidgetTester tester) async {
  // Test code
}, timeout: const Timeout(Duration(minutes: 5)));
```

### Tests Failing Due to Animations

If the tests are failing due to animations, you might need to disable animations during testing. You can do this by wrapping your app with the `MaterialApp.router` widget and setting `builder` to disable animations:

```dart
MaterialApp.router(
  builder: (context, child) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: child!,
    );
  },
  // ...
)
```

## Adding New Tests

When adding new tests, follow these guidelines:

1. Create a new test file if it's testing a new feature area.
2. Add the test to the appropriate existing file if it's related to an existing feature area.
3. Update the `all_tests.dart` file to include your new test file.
4. Make sure your tests work on both web and Android platforms.
5. Document any platform-specific considerations in your test file.