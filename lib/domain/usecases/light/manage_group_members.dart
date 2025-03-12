import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus_dashboard/core/error/failures.dart';
import 'package:nexus_dashboard/domain/entities/light_entity.dart';
import 'package:nexus_dashboard/domain/repositories/light_repository.dart';

class GetGroupMembers {
  final LightRepository repository;

  GetGroupMembers(this.repository);

  Future<Either<Failure, List<LightEntity>>> call(GetGroupMembersParams params) async {
    return await repository.getGroupMembers(params.groupId);
  }
}

class AddBulbToGroup {
  final LightRepository repository;

  AddBulbToGroup(this.repository);

  Future<Either<Failure, bool>> call(AddBulbToGroupParams params) async {
    return await repository.addBulbToGroup(params.groupId, params.bulbIp);
  }
}

class RemoveBulbFromGroup {
  final LightRepository repository;

  RemoveBulbFromGroup(this.repository);

  Future<Either<Failure, bool>> call(RemoveBulbFromGroupParams params) async {
    return await repository.removeBulbFromGroup(params.groupId, params.bulbIp);
  }
}

class GetGroupMembersParams extends Equatable {
  final String groupId;

  const GetGroupMembersParams({required this.groupId});

  @override
  List<Object> get props => [groupId];
}

class AddBulbToGroupParams extends Equatable {
  final String groupId;
  final String bulbIp;

  const AddBulbToGroupParams({
    required this.groupId,
    required this.bulbIp,
  });

  @override
  List<Object> get props => [groupId, bulbIp];
}

class RemoveBulbFromGroupParams extends Equatable {
  final String groupId;
  final String bulbIp;

  const RemoveBulbFromGroupParams({
    required this.groupId,
    required this.bulbIp,
  });

  @override
  List<Object> get props => [groupId, bulbIp];
}