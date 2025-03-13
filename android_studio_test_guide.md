# Running Nexus Dashboard Tests in Android Studio

This guide explains how to run the integration tests for the Nexus Dashboard app in Android Studio.

## Prerequisites

1. Make sure you have Android Studio installed.
2. Open the Nexus Dashboard project in Android Studio.
3. Ensure you have the Flutter and Dart plugins installed in Android Studio.

## Setting Up the Run Configuration

### Method 1: Using the Run Configuration Dialog

1. Click on the dropdown menu in the toolbar (next to the run button).
2. Select "Edit Configurations...".
3. Click the "+" button to add a new configuration.
4. Select "Flutter Test".
5. Configure the test:
   - Name: "Integration Tests" (or any name you prefer)
   - Test file: Select one of the following test files:
     - `integration_test/all_tests.dart` (to run all tests)
     - `integration_test/app_features_test.dart` (to test app features)
     - `integration_test/home_screen_test.dart` (to test home screen)
     - `integration_test/group_management_test.dart` (to test group management)
     - `integration_test/group_details_test.dart` (to test group details)
   - Test mode: "Run in a Flutter Driver session with a specific driver"
   - Driver file: `test_driver/integration_test_driver.dart`
6. Click "Apply" and "OK".

### Method 2: Running from the Test File

1. Open the test file you want to run (e.g., `integration_test/all_tests.dart`).
2. Look for the green triangle (run icon) in the gutter next to the `main()` function.
3. Right-click and select "Run 'all_tests.dart'" or click the green triangle.

## Running Tests on Different Devices

### Running on Android Emulator

1. Start an Android emulator from the AVD Manager in Android Studio.
2. Select the emulator from the device dropdown in the toolbar.
3. Run the tests using one of the methods described above.

### Running on Physical Android Device

1. Connect your Android device to your computer via USB.
2. Enable USB debugging on your device.
3. Select your device from the device dropdown in the toolbar.
4. Run the tests using one of the methods described above.

### Running on Chrome (Web)

1. Select "Chrome (web)" from the device dropdown in the toolbar.
2. Run the tests using one of the methods described above.

## Debugging Tests

1. Set breakpoints in your test files by clicking in the gutter next to the line where you want to pause execution.
2. Instead of running the tests, debug them by:
   - Right-clicking on the test file and selecting "Debug 'file_name.dart'"
   - Using the debug icon instead of the run icon
   - Selecting your run configuration and clicking the debug button (bug icon)
3. When execution reaches a breakpoint, it will pause, allowing you to:
   - Inspect variables
   - Step through code
   - Evaluate expressions
   - View the call stack

## Viewing Test Results

Test results will be displayed in the "Run" tool window at the bottom of Android Studio. You'll see:

- A tree view of all tests with pass/fail status
- Error messages and stack traces for failed tests
- Console output from the tests

## Troubleshooting

### Tests Failing to Start

If tests fail to start, check:

1. The device is properly connected and selected.
2. All dependencies are correctly installed (`flutter pub get`).
3. The test files are in the correct location.

### Tests Failing Due to UI Changes

If tests fail because UI elements can't be found:

1. Update the finders in the test files to match the current UI.
2. Check if element IDs or text have changed.
3. Verify that the app's structure hasn't significantly changed.

### Tests Timing Out

If tests time out:

1. Increase the timeout duration in the test files.
2. Check if the app is taking too long to load or respond.
3. Verify that the app is properly communicating with any backend services.

## Running Tests from the Command Line

You can also run tests from the command line:

```bash
# Run all tests on Android
flutter drive --driver=test_driver/integration_test_driver.dart --target=integration_test/all_tests.dart -d android

# Run all tests on Chrome
flutter drive --driver=test_driver/integration_test_driver.dart --target=integration_test/all_tests.dart -d chrome

# Run specific test file on Android
flutter drive --driver=test_driver/integration_test_driver.dart --target=integration_test/app_features_test.dart -d android
```

This can be useful for running tests in a CI/CD pipeline.