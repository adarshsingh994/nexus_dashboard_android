import 'package:dartz/dartz.dart';
import 'package:nexus_dashboard/core/error/failures.dart';
import 'package:nexus_dashboard/domain/entities/group_entity.dart';
import 'package:nexus_dashboard/domain/repositories/group_repository.dart';

class GetGroups {
  final GroupRepository repository;

  GetGroups(this.repository);

  Future<Either<Failure, List<GroupEntity>>> call() async {
    return await repository.getGroups();
  }
}