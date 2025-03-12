import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus_dashboard/core/error/failures.dart';
import 'package:nexus_dashboard/domain/entities/group_entity.dart';
import 'package:nexus_dashboard/domain/repositories/group_repository.dart';

class UpdateGroup {
  final GroupRepository repository;

  UpdateGroup(this.repository);

  Future<Either<Failure, GroupEntity>> call(UpdateGroupParams params) async {
    return await repository.updateGroup(
      groupId: params.groupId,
      name: params.name,
      description: params.description,
    );
  }
}

class UpdateGroupParams extends Equatable {
  final String groupId;
  final String? name;
  final String? description;

  const UpdateGroupParams({
    required this.groupId,
    this.name,
    this.description,
  });

  @override
  List<Object?> get props => [groupId, name, description];
}