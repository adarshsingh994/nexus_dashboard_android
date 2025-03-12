part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  
  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<GroupEntity> groups;

  const HomeLoaded({required this.groups});

  @override
  List<Object> get props => [groups];
}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object> get props => [message];
}

class HomeOperationError extends HomeState {
  final String message;

  const HomeOperationError({required this.message});

  @override
  List<Object> get props => [message];
}