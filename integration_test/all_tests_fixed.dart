import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// Import test files
import 'app_features_test.dart' as app_features;
import 'simple_test.dart' as simple;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Run tests
  group('All Tests', () {
    // Simple test
    simple.main();
    
    // App features tests
    app_features.main();
  });
}