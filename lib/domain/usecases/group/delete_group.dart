import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus_dashboard/core/error/failures.dart';
import 'package:nexus_dashboard/domain/repositories/group_repository.dart';

class DeleteGroup {
  final GroupRepository repository;

  DeleteGroup(this.repository);

  Future<Either<Failure, bool>> call(DeleteGroupParams params) async {
    return await repository.deleteGroup(params.groupId);
  }
}

class DeleteGroupParams extends Equatable {
  final String groupId;

  const DeleteGroupParams({required this.groupId});

  @override
  List<Object> get props => [groupId];
}