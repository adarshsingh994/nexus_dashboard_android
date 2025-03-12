# Nexus Dashboard

A Flutter application for controlling smart home devices using a RESTful API.

## Network Calls with Dio

This project uses the [dio](https://pub.dev/packages/dio) package for making network calls. Dio is a powerful HTTP client for Dart/Flutter that supports global configuration, interceptors, form data, request cancellation, file downloading, timeout, and more.

### Key Features of Dio Implementation

- **Centralized API Service**: All network calls are managed through the `ApiService` class
- **Interceptors**: Using `PrettyDioLogger` for debugging network requests and responses
- **Error Handling**: Comprehensive error handling with meaningful error messages
- **Type Safety**: Strongly typed responses for better code reliability

## API Service Structure

The `ApiService` class in `lib/services/api_service.dart` provides methods for all API operations:

```dart
class ApiService {
  final String baseUrl;
  late final Dio _dio;

  ApiService({required this.baseUrl}) {
    // Dio configuration
  }

  // Groups API
  Future<List<Group>> fetchGroups() async { ... }
  Future<Group> fetchGroupById(String groupId) async { ... }
  Future<Group> createGroup({...}) async { ... }
  Future<Group> updateGroup({...}) async { ... }
  Future<bool> deleteGroup(String groupId) async { ... }

  // Group Actions API
  Future<Map<String, dynamic>> performGroupAction({...}) async { ... }
  Future<Map<String, dynamic>> turnOnGroup(String groupId) { ... }
  Future<Map<String, dynamic>> turnOffGroup(String groupId) { ... }
  Future<Map<String, dynamic>> setWarmWhite(String groupId, int intensity) { ... }
  Future<Map<String, dynamic>> setColdWhite(String groupId, int intensity) { ... }
  Future<Map<String, dynamic>> setColor(String groupId, List<int> color) { ... }
}
```

## Usage Examples

### Basic Usage

```dart
// Create an instance of ApiService
final apiService = ApiService(baseUrl: 'http://your-api-url/api');

// Fetch all groups
try {
  final groups = await apiService.fetchGroups();
  print('Fetched ${groups.length} groups');
} catch (e) {
  print('Error: $e');
}

// Turn on lights in a group
try {
  final result = await apiService.turnOnGroup('living-room');
  print('Success: ${result['message']}');
} catch (e) {
  print('Error: $e');
}
```

### In a Flutter Widget

```dart
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final ApiService _apiService = ApiService(baseUrl: 'http://your-api-url/api');
  List<Group> _groups = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchGroups();
  }

  Future<void> _fetchGroups() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final groups = await _apiService.fetchGroups();
      setState(() {
        _groups = groups;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error
    }
  }

  // Rest of the widget...
}
```

## Demo Pages

The project includes two demo pages to showcase the Dio-based API service:

1. **Group Management Page**: A complete UI for managing groups and controlling lights
   - Path: `lib/pages/group_management_page.dart`
   - Features: Create groups, view groups, control lights, delete groups

2. **API Examples Widget**: A simple UI with buttons to demonstrate various API calls
   - Path: `lib/examples/api_usage_examples.dart`
   - Features: Examples of all API operations with console output

## Benefits of Using Dio

- **Interceptors**: Add logging, authentication, and error handling in a centralized way
- **Transformers**: Transform request/response data before it's used
- **Cancellation**: Cancel requests when they're no longer needed
- **Timeouts**: Configure connection and receive timeouts
- **FormData**: Easily handle form data and file uploads
- **Download/Upload**: Progress tracking for file operations
- **HTTP/2 Support**: Better performance with multiplexing

## Getting Started

1. Ensure you have Flutter installed
2. Clone this repository
3. Run `flutter pub get` to install dependencies
4. Update the API base URL in the code to match your API server
5. Run the app with `flutter run`
