import 'package:dio/dio.dart';
import 'package:nexus_dashboard/core/error/exceptions.dart';
import 'package:nexus_dashboard/data/models/group_model.dart';
import 'package:nexus_dashboard/data/models/group_state_model.dart';
import 'package:nexus_dashboard/data/models/light_model.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

abstract class RemoteDataSource {
  // Groups
  Future<List<GroupModel>> getGroups();
  Future<GroupModel> getGroupById(String groupId);
  Future<GroupModel> createGroup({
    required String id,
    required String name,
    required String description,
  });
  Future<GroupModel> updateGroup({
    required String groupId,
    String? name,
    String? description,
  });
  Future<bool> deleteGroup(String groupId);
  Future<Map<String, dynamic>> turnOnGroup(String groupId);
  Future<Map<String, dynamic>> turnOffGroup(String groupId);
  Future<Map<String, dynamic>> setWarmWhite(String groupId, int intensity);
  Future<Map<String, dynamic>> setColdWhite(String groupId, int intensity);
  Future<Map<String, dynamic>> setColor(String groupId, List<int> color);
  Future<GroupStateModel> getGroupState(String groupId);

  // Lights
  Future<List<LightModel>> getLights();
  Future<List<LightModel>> getUngroupedLights();
  Future<List<LightModel>> getGroupMembers(String groupId);
  Future<bool> addBulbToGroup(String groupId, String bulbIp);
  Future<bool> removeBulbFromGroup(String groupId, String bulbIp);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final Dio dio;
  final String baseUrl;

  RemoteDataSourceImpl({required this.baseUrl}) : dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      contentType: 'application/json',
      headers: {
        'Accept': 'application/json',
      },
    ),
  ) {
    // Add logger interceptor for debugging
    dio.interceptors.add(
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
    print('DEBUG: _handleResponse called with status code: ${response.statusCode}');
    final jsonData = response.data;
    print('DEBUG: Response data: $jsonData');
    
    if (jsonData['success'] == true) {
      print('DEBUG: Success is true');
      // For responses with data field
      if (jsonData['data'] != null) {
        print('DEBUG: Data field exists, converting data field');
        return converter(jsonData['data']);
      }
      // For responses without data field (like delete operations)
      else {
        print('DEBUG: No data field, converting entire response');
        return converter(jsonData);
      }
    } else {
      print('DEBUG: Success is not true, throwing exception');
      throw ServerException(
        message: jsonData['message'] ?? 'Unknown error',
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
        throw ServerException(
          message: jsonData['message'] ?? 'Unknown error',
        );
      }
    }
    
    // If we can't determine the format, just try to convert it
    return converter(jsonData);
  }

  // Generic error handler
  Future<T> _handleRequest<T>(Future<Response> request, T Function(dynamic data) converter, {bool isGroupAction = false}) async {
    print('DEBUG: _handleRequest called');
    try {
      print('DEBUG: Awaiting request...');
      final response = await request;
      print('DEBUG: Request completed with status code: ${response.statusCode}');
      print('DEBUG: Response data: ${response.data}');
      
      final result = isGroupAction
          ? _handleGroupActionResponse(response, converter)
          : _handleResponse(response, converter);
      
      print('DEBUG: Response handled successfully');
      return result;
    } on DioException catch (e) {
      print('DEBUG: DioException caught: ${e.message}');
      print('DEBUG: DioException type: ${e.type}');
      print('DEBUG: DioException response: ${e.response}');
      
      if (e.response != null) {
        final errorData = e.response!.data;
        print('DEBUG: Error data: $errorData');
        final message = errorData is Map ? errorData['message'] ?? e.message : e.message;
        throw ServerException(message: message ?? 'Server error');
      } else {
        throw NetworkException(message: 'Network error: ${e.message}');
      }
    } catch (e) {
      print('DEBUG: Unexpected error: $e');
      throw ServerException(message: 'Error: $e');
    }
  }

  // GROUPS API

  @override
  Future<List<GroupModel>> getGroups() async {
    return _handleRequest(
      dio.get('/groups'),
      (data) {
        return (data['groups'] as List).map((groupJson) => GroupModel.fromJson(groupJson)).toList();
      },
    );
  }

  @override
  Future<GroupModel> getGroupById(String groupId) async {
    return _handleRequest(
      dio.get('/groups/$groupId'),
      (data) => GroupModel.fromJson(data['group']),
    );
  }

  @override
  Future<GroupModel> createGroup({
    required String id,
    required String name,
    required String description,
  }) async {
    return _handleRequest(
      dio.post(
        '/groups',
        data: {
          'id': id,
          'name': name,
          'description': description,
        },
      ),
      (data) => GroupModel.fromJson(data),
    );
  }

  @override
  Future<GroupModel> updateGroup({
    required String groupId,
    String? name,
    String? description,
  }) async {
    final Map<String, dynamic> data = {};
    if (name != null) data['name'] = name;
    if (description != null) data['description'] = description;

    return _handleRequest(
      dio.put('/groups/$groupId', data: data),
      (data) => GroupModel.fromJson(data),
    );
  }

  @override
  Future<bool> deleteGroup(String groupId) async {
    return _handleRequest(
      dio.delete('/groups/$groupId'),
      (data) {
        // Check if the response indicates success
        if (data is Map && data['success'] == true) {
          return true;
        }
        return true; // Fallback for backward compatibility
      },
    );
  }

  @override
  Future<Map<String, dynamic>> turnOnGroup(String groupId) {
    return performGroupAction(groupId: groupId, action: 'turnOn');
  }

  @override
  Future<Map<String, dynamic>> turnOffGroup(String groupId) {
    return performGroupAction(groupId: groupId, action: 'turnOff');
  }

  @override
  Future<Map<String, dynamic>> setWarmWhite(String groupId, int intensity) {
    return performGroupAction(
      groupId: groupId,
      action: 'setWarmWhite',
      params: {'intensity': intensity},
    );
  }

  @override
  Future<Map<String, dynamic>> setColdWhite(String groupId, int intensity) {
    return performGroupAction(
      groupId: groupId,
      action: 'setColdWhite',
      params: {'intensity': intensity},
    );
  }

  @override
  Future<Map<String, dynamic>> setColor(String groupId, List<int> color) {
    return performGroupAction(
      groupId: groupId,
      action: 'setColor',
      params: {'color': color},
    );
  }
  
  @override
  Future<GroupStateModel> getGroupState(String groupId) async {
    return _handleRequest(
      dio.get('/groups/$groupId/state'),
      (data) => GroupStateModel.fromJson(data),
      isGroupAction: true,
    );
  }

  // Helper method for group actions
  Future<Map<String, dynamic>> performGroupAction({
    required String groupId,
    required String action,
    Map<String, dynamic>? params,
  }) async {
    final Map<String, dynamic> data = {'action': action};
    if (params != null) data['params'] = params;

    return _handleRequest(
      dio.post('/groups/$groupId/actions', data: data),
      (data) => data as Map<String, dynamic>,
      isGroupAction: true,
    );
  }

  // LIGHTS API

  @override
  Future<List<LightModel>> getLights() async {
    return _handleRequest(
      dio.get('/lights'),
      (data) => (data['bulbs'] as List).map((lightJson) => LightModel.fromJson(lightJson)).toList(),
    );
  }

  @override
  Future<List<LightModel>> getUngroupedLights() async {
    print('DEBUG: RemoteDataSourceImpl.getUngroupedLights() called');
    print('DEBUG: Making API request to: ${dio.options.baseUrl}/lights?grouped=false');
    
    try {
      // Make a direct API call to bypass the _handleRequest method
      print('DEBUG: Making direct API call');
      final response = await dio.get('/lights', queryParameters: {'grouped': false});
      print('DEBUG: Direct API call completed with status code: ${response.statusCode}');
      print('DEBUG: Direct API response data: ${response.data}');
      
      final jsonData = response.data;
      
      // Check if the response has the expected structure
      if (jsonData is! Map) {
        print('DEBUG: Response is not a Map: $jsonData');
        return [];
      }
      
      if (jsonData['success'] != true) {
        print('DEBUG: Success is not true: ${jsonData['success']}');
        return [];
      }
      
      if (jsonData['data'] == null) {
        print('DEBUG: No data field in response');
        return [];
      }
      
      final data = jsonData['data'];
      if (data['bulbs'] == null) {
        print('DEBUG: No bulbs field in data');
        return [];
      }
      
      final bulbs = data['bulbs'] as List;
      print('DEBUG: Found ${bulbs.length} ungrouped lights');
      
      final lights = bulbs.map((lightJson) => LightModel.fromJson(lightJson)).toList();
      print('DEBUG: Converted to ${lights.length} LightModel objects');
      
      return lights;
    } on DioException catch (e) {
      print('DEBUG: DioException in getUngroupedLights: ${e.message}');
      print('DEBUG: DioException type: ${e.type}');
      print('DEBUG: DioException response: ${e.response?.data}');
      rethrow;
    } catch (e) {
      print('DEBUG: Unexpected error in getUngroupedLights: $e');
      rethrow;
    }
  }

  @override
  Future<List<LightModel>> getGroupMembers(String groupId) async {
    print('DEBUG: RemoteDataSourceImpl.getGroupMembers() called for group: $groupId');
    print('DEBUG: Making API request to: ${dio.options.baseUrl}/groups/$groupId/members');
    
    try {
      // Make a direct API call to bypass the _handleRequest method
      print('DEBUG: Making direct API call');
      final response = await dio.get('/groups/$groupId/members');
      print('DEBUG: Direct API call completed with status code: ${response.statusCode}');
      print('DEBUG: Direct API response data: ${response.data}');
      
      final jsonData = response.data;
      
      // Check if the response has the expected structure
      if (jsonData is! Map) {
        print('DEBUG: Response is not a Map: $jsonData');
        return [];
      }
      
      if (jsonData['success'] != true) {
        print('DEBUG: Success is not true: ${jsonData['success']}');
        return [];
      }
      
      if (jsonData['data'] == null) {
        print('DEBUG: No data field in response');
        return [];
      }
      
      final data = jsonData['data'];
      if (data['bulbs'] == null) {
        print('DEBUG: No bulbs field in data');
        return [];
      }
      
      final bulbs = data['bulbs'] as List;
      print('DEBUG: Found ${bulbs.length} group member lights');
      
      final lights = bulbs.map((lightJson) => LightModel.fromJson(lightJson)).toList();
      print('DEBUG: Converted to ${lights.length} LightModel objects');
      
      return lights;
    } on DioException catch (e) {
      print('DEBUG: DioException in getGroupMembers: ${e.message}');
      print('DEBUG: DioException type: ${e.type}');
      print('DEBUG: DioException response: ${e.response?.data}');
      rethrow;
    } catch (e) {
      print('DEBUG: Unexpected error in getGroupMembers: $e');
      rethrow;
    }
  }

  @override
  Future<bool> addBulbToGroup(String groupId, String bulbIp) async {
    return _handleRequest(
      dio.post(
        '/groups/$groupId/members',
        data: {
          'type': 'bulb',
          'id': bulbIp,
        },
      ),
      (data) => true,
    );
  }

  @override
  Future<bool> removeBulbFromGroup(String groupId, String bulbIp) async {
    return _handleRequest(
      dio.delete(
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