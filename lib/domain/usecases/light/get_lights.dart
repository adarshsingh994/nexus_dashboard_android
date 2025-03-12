import 'package:dartz/dartz.dart';
import 'package:nexus_dashboard/core/error/failures.dart';
import 'package:nexus_dashboard/domain/entities/light_entity.dart';
import 'package:nexus_dashboard/domain/repositories/light_repository.dart';

class GetLights {
  final LightRepository repository;

  GetLights(this.repository);

  Future<Either<Failure, List<LightEntity>>> call() async {
    return await repository.getLights();
  }
}

class GetUngroupedLights {
  final LightRepository repository;

  GetUngroupedLights(this.repository);

  Future<Either<Failure, List<LightEntity>>> call() async {
    return await repository.getUngroupedLights();
  }
}