import 'package:dartz/dartz.dart';
import 'package:nexus_dashboard/core/error/exceptions.dart';
import 'package:nexus_dashboard/core/error/failures.dart';
import 'package:nexus_dashboard/core/network/network_info.dart';
import 'package:nexus_dashboard/data/datasources/remote_data_source.dart';
import 'package:nexus_dashboard/domain/entities/light_entity.dart';
import 'package:nexus_dashboard/domain/repositories/light_repository.dart';

class LightRepositoryImpl implements LightRepository {
  final RemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  LightRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<LightEntity>>> getLights() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteLights = await remoteDataSource.getLights();
        return Right(remoteLights);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<LightEntity>>> getUngroupedLights() async {
    print('DEBUG: LightRepositoryImpl.getUngroupedLights() called');
    if (await networkInfo.isConnected) {
      try {
        print('DEBUG: Network is connected, calling remoteDataSource.getUngroupedLights()');
        final remoteLights = await remoteDataSource.getUngroupedLights();
        print('DEBUG: Got ${remoteLights.length} ungrouped lights from remote data source');
        return Right(remoteLights);
      } on ServerException catch (e) {
        print('DEBUG: ServerException in getUngroupedLights: ${e.message}');
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        print('DEBUG: NetworkException in getUngroupedLights: ${e.message}');
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        print('DEBUG: Unexpected error in getUngroupedLights: $e');
        return Left(ServerFailure(message: 'Unexpected error: $e'));
      }
    } else {
      print('DEBUG: No internet connection in getUngroupedLights');
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<LightEntity>>> getGroupMembers(String groupId) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteLights = await remoteDataSource.getGroupMembers(groupId);
        return Right(remoteLights);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> addBulbToGroup(String groupId, String bulbIp) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.addBulbToGroup(groupId, bulbIp);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> removeBulbFromGroup(String groupId, String bulbIp) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.removeBulbFromGroup(groupId, bulbIp);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}