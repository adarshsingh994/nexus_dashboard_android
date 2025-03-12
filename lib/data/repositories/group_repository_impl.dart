import 'package:dartz/dartz.dart';
import 'package:nexus_dashboard/core/error/exceptions.dart';
import 'package:nexus_dashboard/core/error/failures.dart';
import 'package:nexus_dashboard/core/network/network_info.dart';
import 'package:nexus_dashboard/data/datasources/remote_data_source.dart';
import 'package:nexus_dashboard/domain/entities/group_entity.dart';
import 'package:nexus_dashboard/domain/entities/group_state_entity.dart';
import 'package:nexus_dashboard/domain/repositories/group_repository.dart';

class GroupRepositoryImpl implements GroupRepository {
  final RemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  GroupRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<GroupEntity>>> getGroups() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteGroups = await remoteDataSource.getGroups();
        return Right(remoteGroups);
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
  Future<Either<Failure, GroupEntity>> getGroupById(String groupId) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteGroup = await remoteDataSource.getGroupById(groupId);
        return Right(remoteGroup);
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
  Future<Either<Failure, GroupEntity>> createGroup({
    required String id,
    required String name,
    required String description,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteGroup = await remoteDataSource.createGroup(
          id: id,
          name: name,
          description: description,
        );
        return Right(remoteGroup);
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
  Future<Either<Failure, GroupEntity>> updateGroup({
    required String groupId,
    String? name,
    String? description,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteGroup = await remoteDataSource.updateGroup(
          groupId: groupId,
          name: name,
          description: description,
        );
        return Right(remoteGroup);
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
  Future<Either<Failure, bool>> deleteGroup(String groupId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.deleteGroup(groupId);
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
  Future<Either<Failure, Map<String, dynamic>>> turnOnGroup(String groupId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.turnOnGroup(groupId);
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
  Future<Either<Failure, Map<String, dynamic>>> turnOffGroup(String groupId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.turnOffGroup(groupId);
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
  Future<Either<Failure, Map<String, dynamic>>> setWarmWhite(String groupId, int intensity) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.setWarmWhite(groupId, intensity);
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
  Future<Either<Failure, Map<String, dynamic>>> setColdWhite(String groupId, int intensity) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.setColdWhite(groupId, intensity);
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
  Future<Either<Failure, Map<String, dynamic>>> setColor(String groupId, List<int> color) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.setColor(groupId, color);
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
  Future<Either<Failure, GroupStateEntity>> getGroupState(String groupId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getGroupState(groupId);
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