import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus_dashboard/core/error/failures.dart';
import 'package:nexus_dashboard/domain/repositories/group_repository.dart';

class SetGroupColor {
  final GroupRepository repository;

  SetGroupColor(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call(SetGroupColorParams params) async {
    return await repository.setColor(params.groupId, params.color);
  }
}

class SetGroupColorParams extends Equatable {
  final String groupId;
  final List<int> color;

  const SetGroupColorParams({
    required this.groupId,
    required this.color,
  });

  @override
  List<Object> get props => [groupId, color];
}