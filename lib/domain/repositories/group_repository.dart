import 'package:dartz/dartz.dart';
import 'package:nexus_dashboard/core/error/failures.dart';
import 'package:nexus_dashboard/domain/entities/group_entity.dart';
import 'package:nexus_dashboard/domain/entities/group_state_entity.dart';

abstract class GroupRepository {
  /// Get all groups
  Future<Either<Failure, List<GroupEntity>>> getGroups();
  
  /// Get a specific group by ID
  Future<Either<Failure, GroupEntity>> getGroupById(String groupId);
  
  /// Create a new group
  Future<Either<Failure, GroupEntity>> createGroup({
    required String id,
    required String name,
    required String description,
  });
  
  /// Update an existing group
  Future<Either<Failure, GroupEntity>> updateGroup({
    required String groupId,
    String? name,
    String? description,
  });
  
  /// Delete a group
  Future<Either<Failure, bool>> deleteGroup(String groupId);
  
  /// Turn on all lights in a group
  Future<Either<Failure, Map<String, dynamic>>> turnOnGroup(String groupId);
  
  /// Turn off all lights in a group
  Future<Either<Failure, Map<String, dynamic>>> turnOffGroup(String groupId);
  
  /// Set warm white for all lights in a group
  Future<Either<Failure, Map<String, dynamic>>> setWarmWhite(String groupId, int intensity);
  
  /// Set cold white for all lights in a group
  Future<Either<Failure, Map<String, dynamic>>> setColdWhite(String groupId, int intensity);
  
  /// Set color for all lights in a group
  Future<Either<Failure, Map<String, dynamic>>> setColor(String groupId, List<int> color);
  
  /// Get the current state of a group
  Future<Either<Failure, GroupStateEntity>> getGroupState(String groupId);
}