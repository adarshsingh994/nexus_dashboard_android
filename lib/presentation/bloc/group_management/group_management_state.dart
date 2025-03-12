part of 'group_management_bloc.dart';

abstract class GroupManagementState extends Equatable {
  const GroupManagementState();
  
  @override
  List<Object> get props => [];
}

class GroupManagementInitial extends GroupManagementState {}

class GroupManagementLoading extends GroupManagementState {}

class GroupManagementLoaded extends GroupManagementState {
  final List<GroupEntity> groups;

  const GroupManagementLoaded({required this.groups});

  @override
  List<Object> get props => [groups];
}

class GroupManagementError extends GroupManagementState {
  final String message;

  const GroupManagementError({required this.message});

  @override
  List<Object> get props => [message];
}

class GroupManagementOperationLoading extends GroupManagementState {}

class GroupManagementOperationSuccess extends GroupManagementState {
  final String message;

  const GroupManagementOperationSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class GroupManagementOperationError extends GroupManagementState {
  final String message;

  const GroupManagementOperationError({required this.message});

  @override
  List<Object> get props => [message];
}