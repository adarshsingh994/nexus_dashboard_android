import 'package:get_it/get_it.dart';
import 'package:nexus_dashboard/core/network/network_info.dart';
import 'package:nexus_dashboard/data/datasources/remote_data_source.dart';
import 'package:nexus_dashboard/data/repositories/group_repository_impl.dart';
import 'package:nexus_dashboard/data/repositories/light_repository_impl.dart';
import 'package:nexus_dashboard/domain/repositories/group_repository.dart';
import 'package:nexus_dashboard/domain/repositories/light_repository.dart';
import 'package:nexus_dashboard/domain/usecases/group/create_group.dart';
import 'package:nexus_dashboard/domain/usecases/group/delete_group.dart';
import 'package:nexus_dashboard/domain/usecases/group/get_group_by_id.dart';
import 'package:nexus_dashboard/domain/usecases/group/get_groups.dart';
import 'package:nexus_dashboard/domain/usecases/group/set_group_color.dart';
import 'package:nexus_dashboard/domain/usecases/group/set_white_intensity.dart';
import 'package:nexus_dashboard/domain/usecases/group/toggle_group_power.dart';
import 'package:nexus_dashboard/domain/usecases/group/update_group.dart';
import 'package:nexus_dashboard/domain/usecases/light/get_lights.dart';
import 'package:nexus_dashboard/domain/usecases/light/manage_group_members.dart';
import 'package:nexus_dashboard/presentation/bloc/group/group_bloc.dart';
import 'package:nexus_dashboard/presentation/bloc/group_details/group_details_bloc.dart';
import 'package:nexus_dashboard/presentation/bloc/group_management/group_management_bloc.dart';
import 'package:nexus_dashboard/presentation/bloc/home/home_bloc.dart';
import 'package:nexus_dashboard/presentation/bloc/light/light_bloc.dart';
import 'package:nexus_dashboard/presentation/bloc/theme/theme_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Groups
  // Bloc
  sl.registerFactory(
    () => HomeBloc(
      getGroups: sl(),
      turnOnGroup: sl(),
      turnOffGroup: sl(),
      setColor: sl(),
      setWarmWhite: sl(),
      setColdWhite: sl(),
    ),
  );
  
  sl.registerFactory(
    () => GroupBloc(
      getGroups: sl(),
      getGroupById: sl(),
      turnOnGroup: sl(),
      turnOffGroup: sl(),
      setColor: sl(),
      setWarmWhite: sl(),
      setColdWhite: sl(),
    ),
  );
  
  sl.registerFactory(
    () => GroupDetailsBloc(
      getGroupById: sl(),
      createGroup: sl(),
      updateGroup: sl(),
      deleteGroup: sl(),
      getGroupMembers: sl(),
      getUngroupedLights: sl(),
      addBulbToGroup: sl(),
      removeBulbFromGroup: sl(),
    ),
  );
  
  sl.registerFactory(
    () => GroupManagementBloc(
      getGroups: sl(),
      createGroup: sl(),
      updateGroup: sl(),
      deleteGroup: sl(),
    ),
  );

  //! Features - Lights
  // Bloc
  sl.registerFactory(
    () => LightBloc(
      getLights: sl(),
      getUngroupedLights: sl(),
    ),
  );

  //! Features - Theme
  // Bloc
  sl.registerFactory(
    () => ThemeBloc(),
  );

  // Use cases
  sl.registerLazySingleton(() => GetGroups(sl()));
  sl.registerLazySingleton(() => GetGroupById(sl()));
  sl.registerLazySingleton(() => CreateGroup(sl()));
  sl.registerLazySingleton(() => UpdateGroup(sl()));
  sl.registerLazySingleton(() => DeleteGroup(sl()));
  sl.registerLazySingleton(() => TurnOnGroup(sl()));
  sl.registerLazySingleton(() => TurnOffGroup(sl()));
  sl.registerLazySingleton(() => SetGroupColor(sl()));
  sl.registerLazySingleton(() => SetWarmWhite(sl()));
  sl.registerLazySingleton(() => SetColdWhite(sl()));
  
  sl.registerLazySingleton(() => GetLights(sl()));
  sl.registerLazySingleton(() => GetUngroupedLights(sl()));
  sl.registerLazySingleton(() => GetGroupMembers(sl()));
  sl.registerLazySingleton(() => AddBulbToGroup(sl()));
  sl.registerLazySingleton(() => RemoveBulbFromGroup(sl()));

  // Repository
  sl.registerLazySingleton<GroupRepository>(
    () => GroupRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  
  sl.registerLazySingleton<LightRepository>(
    () => LightRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<RemoteDataSource>(
    () => RemoteDataSourceImpl(baseUrl: 'http://192.168.18.4:3000/api'),
  );

  // Debug API endpoint
  print('DEBUG: API endpoint set to: http://192.168.18.4:3000/api');

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
}