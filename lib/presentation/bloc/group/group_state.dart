part of 'group_bloc.dart';

abstract class GroupState extends Equatable {
  const GroupState();
  
  @override
  List<Object> get props => [];
}

class GroupInitial extends GroupState {}

class GroupLoading extends GroupState {}

class GroupLoaded extends GroupState {
  final GroupEntity group;

  const GroupLoaded({required this.group});

  @override
  List<Object> get props => [group];
}

class GroupError extends GroupState {
  final String message;

  const GroupError({required this.message});

  @override
  List<Object> get props => [message];
}

class GroupOperationError extends GroupState {
  final String message;

  const GroupOperationError({required this.message});

  @override
  List<Object> get props => [message];
}