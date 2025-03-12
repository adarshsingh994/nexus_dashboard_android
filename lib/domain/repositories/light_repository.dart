import 'package:dartz/dartz.dart';
import 'package:nexus_dashboard/core/error/failures.dart';
import 'package:nexus_dashboard/domain/entities/light_entity.dart';

abstract class LightRepository {
  /// Get all lights
  Future<Either<Failure, List<LightEntity>>> getLights();
  
  /// Get only ungrouped lights
  Future<Either<Failure, List<LightEntity>>> getUngroupedLights();
  
  /// Get group members (bulbs)
  Future<Either<Failure, List<LightEntity>>> getGroupMembers(String groupId);
  
  /// Add a bulb to group
  Future<Either<Failure, bool>> addBulbToGroup(String groupId, String bulbIp);
  
  /// Remove a bulb from group
  Future<Either<Failure, bool>> removeBulbFromGroup(String groupId, String bulbIp);
}