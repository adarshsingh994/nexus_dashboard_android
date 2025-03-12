import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:nexus_dashboard/models/group.dart';
import 'package:nexus_dashboard/models/group_state.dart';
import 'package:nexus_dashboard/models/light.dart';

class ApiService {
  final String baseUrl;
  late final Dio _dio;

  ApiService({required this.baseUrl}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        contentType: 'application/json',
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    // Add logger interceptor for debugging
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        compact: true,
      ),
    );
  }

  // Generic response handler for standard API responses
  T _handleResponse<T>(Response response, T Function(dynamic data) converter) {
    final jsonData = response.data;
    
    if (jsonData['success'] == true && jsonData['data'] != null) {
      return converter(jsonData['data']);
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        message: jsonData['message'] ?? 'Unknown error',
        response: response,
      );
    }
  }
  
  // Response handler for group action responses
  T _handleGroupActionResponse<T>(Response response, T Function(dynamic data) converter) {
    final jsonData = response.data;
    
    // Group action responses have a different format
    if (jsonData is Map) {
      // Check if it's a success response (200 or 207)
      if (jsonData.containsKey('overall_success')) {
        return converter(jsonData);
      } else if (jsonData.containsKey('message')) {
        // It's an error response
        throw DioException(
          requestOptions: response.requestOptions,
          message: jsonData['message'] ?? 'Unknown error',
          response: response,
        );
      }
    }
    
    // If we can't determine the format, just try to convert it
    return converter(jsonData);
  }

  // Generic error handler
  Future<T> _handleRequest<T>(Future<Response> request, T Function(dynamic data) converter, {bool isGroupAction = false}) async {
    try {
      final response = await request;
      return isGroupAction
          ? _handleGroupActionResponse(response, converter)
          : _handleResponse(response, converter);
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data;
        final message = errorData is Map ? errorData['message'] ?? e.message : e.message;
        throw Exception(message);
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // GROUPS API

  // Get all groups
  Future<List<Group>> fetchGroups() async {
    return _handleRequest(
      _dio.get('/groups'),
      (data) {
        // Debug log the raw API response
        print('Raw API response: $data');
        
        final groups = (data['groups'] as List).map((groupJson) {
          // Debug log each group JSON
          print('Group JSON: $groupJson');
          return Group.fromJson(groupJson);
        }).toList();
        
        // Debug log the parsed groups
        for (final group in groups) {
          print('Parsed group: ${group.id}, state=${group.state}, isOn=${group.state?.isOn}');
        }
        
        return groups;
      },
    );
  }

  // Get a specific group by ID
  Future<Group> fetchGroupById(String groupId) async {
    return _handleRequest(
      _dio.get('/groups/$groupId'),
      (data) => Group.fromJson(data['group']),
    );
  }

  // Create a new group
  Future<Group> createGroup({
    required String id,
    required String name,
    required String description,
  }) async {
    return _handleRequest(
      _dio.post(
        '/groups',
        data: {
          'id': id,
          'name': name,
          'description': description,
        },
      ),
      (data) => Group.fromJson(data),
    );
  }

  // Update an existing group
  Future<Group> updateGroup({
    required String groupId,
    String? name,
    String? description,
  }) async {
    final Map<String, dynamic> data = {};
    if (name != null) data['name'] = name;
    if (description != null) data['description'] = description;

    return _handleRequest(
      _dio.put('/groups/$groupId', data: data),
      (data) => Group.fromJson(data),
    );
  }

  // Delete a group
  Future<bool> deleteGroup(String groupId) async {
    return _handleRequest(
      _dio.delete('/groups/$groupId'),
      (data) => true,
    );
  }

  // GROUP ACTIONS API

  // Perform an action on a group
  Future<Map<String, dynamic>> performGroupAction({
    required String groupId,
    required String action,
    Map<String, dynamic>? params,
  }) async {
    final Map<String, dynamic> data = {'action': action};
    if (params != null) data['params'] = params;

    return _handleRequest(
      _dio.post('/groups/$groupId/actions', data: data),
      (data) => data as Map<String, dynamic>,
      isGroupAction: true, // Use the group action handler
    );
  }

  // Turn on all lights in a group
  Future<Map<String, dynamic>> turnOnGroup(String groupId) {
    return performGroupAction(groupId: groupId, action: 'turnOn');
  }

  // Turn off all lights in a group
  Future<Map<String, dynamic>> turnOffGroup(String groupId) {
    return performGroupAction(groupId: groupId, action: 'turnOff');
  }

  // Set warm white for all lights in a group
  Future<Map<String, dynamic>> setWarmWhite(String groupId, int intensity) {
    return performGroupAction(
      groupId: groupId,
      action: 'setWarmWhite',
      params: {'intensity': intensity},
    );
  }

  // Set cold white for all lights in a group
  Future<Map<String, dynamic>> setColdWhite(String groupId, int intensity) {
    return performGroupAction(
      groupId: groupId,
      action: 'setColdWhite',
      params: {'intensity': intensity},
    );
  }

  // Set color for all lights in a group
  Future<Map<String, dynamic>> setColor(String groupId, List<int> color) {
    return performGroupAction(
      groupId: groupId,
      action: 'setColor',
      params: {'color': color},
    );
  }
  
  // Get the current state of a group
  Future<GroupState> fetchGroupState(String groupId) async {
    return _handleRequest(
      _dio.get('/groups/$groupId/state'),
      (data) => GroupState.fromJson(data),
      isGroupAction: true, // Use the group action handler
    );
  }

  // LIGHTS API

  // Get all lights
  Future<List<Light>> fetchLights() async {
    return _handleRequest(
      _dio.get('/lights'),
      (data) => (data['bulbs'] as List).map((lightJson) => Light.fromJson(lightJson)).toList(),
    );
  }

  // Get only ungrouped lights
  Future<List<Light>> fetchUngroupedLights() async {
    return _handleRequest(
      _dio.get('/lights', queryParameters: {'grouped': false}),
      (data) => (data['bulbs'] as List).map((lightJson) => Light.fromJson(lightJson)).toList(),
    );
  }

  // GROUP MEMBERS API

  // Get group members (bulbs)
  Future<List<Light>> fetchGroupMembers(String groupId) async {
    return _handleRequest(
      _dio.get('/groups/$groupId/members'),
      (data) => (data['bulbs'] as List).map((lightJson) => Light.fromJson(lightJson)).toList(),
    );
  }

  // Add a bulb to group
  Future<bool> addBulbToGroup(String groupId, String bulbIp) async {
    return _handleRequest(
      _dio.post(
        '/groups/$groupId/members',
        data: {
          'type': 'bulb',
          'id': bulbIp,
        },
      ),
      (data) => true,
    );
  }

  // Remove a bulb from group
  Future<bool> removeBulbFromGroup(String groupId, String bulbIp) async {
    return _handleRequest(
      _dio.delete(
        '/groups/$groupId/members',
        data: {
          'type': 'bulb',
          'id': bulbIp,
        },
      ),
      (data) => true,
    );
  }
}