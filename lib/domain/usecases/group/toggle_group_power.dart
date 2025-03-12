import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus_dashboard/core/error/failures.dart';
import 'package:nexus_dashboard/domain/repositories/group_repository.dart';

class TurnOnGroup {
  final GroupRepository repository;

  TurnOnGroup(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call(TurnOnGroupParams params) async {
    return await repository.turnOnGroup(params.groupId);
  }
}

class TurnOffGroup {
  final GroupRepository repository;

  TurnOffGroup(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call(TurnOffGroupParams params) async {
    return await repository.turnOffGroup(params.groupId);
  }
}

class TurnOnGroupParams extends Equatable {
  final String groupId;

  const TurnOnGroupParams({required this.groupId});

  @override
  List<Object> get props => [groupId];
}

class TurnOffGroupParams extends Equatable {
  final String groupId;

  const TurnOffGroupParams({required this.groupId});

  @override
  List<Object> get props => [groupId];
}