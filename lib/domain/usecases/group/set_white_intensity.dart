import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus_dashboard/core/error/failures.dart';
import 'package:nexus_dashboard/domain/repositories/group_repository.dart';

class SetWarmWhite {
  final GroupRepository repository;

  SetWarmWhite(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call(SetWarmWhiteParams params) async {
    return await repository.setWarmWhite(params.groupId, params.intensity);
  }
}

class SetColdWhite {
  final GroupRepository repository;

  SetColdWhite(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call(SetColdWhiteParams params) async {
    return await repository.setColdWhite(params.groupId, params.intensity);
  }
}

class SetWarmWhiteParams extends Equatable {
  final String groupId;
  final int intensity;

  const SetWarmWhiteParams({
    required this.groupId,
    required this.intensity,
  });

  @override
  List<Object> get props => [groupId, intensity];
}

class SetColdWhiteParams extends Equatable {
  final String groupId;
  final int intensity;

  const SetColdWhiteParams({
    required this.groupId,
    required this.intensity,
  });

  @override
  List<Object> get props => [groupId, intensity];
}