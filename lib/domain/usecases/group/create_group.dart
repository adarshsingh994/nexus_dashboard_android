import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus_dashboard/core/error/failures.dart';
import 'package:nexus_dashboard/domain/entities/group_entity.dart';
import 'package:nexus_dashboard/domain/repositories/group_repository.dart';

class CreateGroup {
  final GroupRepository repository;

  CreateGroup(this.repository);

  Future<Either<Failure, GroupEntity>> call(CreateGroupParams params) async {
    return await repository.createGroup(
      id: params.id,
      name: params.name,
      description: params.description,
    );
  }
}

class CreateGroupParams extends Equatable {
  final String id;
  final String name;
  final String description;

  const CreateGroupParams({
    required this.id,
    required this.name,
    required this.description,
  });

  @override
  List<Object> get props => [id, name, description];
}