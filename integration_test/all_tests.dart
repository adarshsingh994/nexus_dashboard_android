import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// Import all test files
import 'app_features_test.dart' as app_features;
import 'home_screen_test.dart' as home_screen;
import 'group_management_test.dart' as group_management;
import 'group_details_test.dart' as group_details;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('All Integration Tests', () {
    // Run all test groups from each test file
    app_features.main();
    home_screen.main();
    group_management.main();
    group_details.main();
  });
}