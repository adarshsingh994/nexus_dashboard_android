import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus_dashboard/core/error/failures.dart';
import 'package:nexus_dashboard/domain/entities/group_entity.dart';
import 'package:nexus_dashboard/domain/repositories/group_repository.dart';

class GetGroupById {
  final GroupRepository repository;

  GetGroupById(this.repository);

  Future<Either<Failure, GroupEntity>> call(GetGroupByIdParams params) async {
    return await repository.getGroupById(params.groupId);
  }
}

class GetGroupByIdParams extends Equatable {
  final String groupId;

  const GetGroupByIdParams({required this.groupId});

  @override
  List<Object> get props => [groupId];
}