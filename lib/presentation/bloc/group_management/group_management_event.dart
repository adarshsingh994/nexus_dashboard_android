part of 'group_management_bloc.dart';

abstract class GroupManagementEvent extends Equatable {
  const GroupManagementEvent();

  @override
  List<Object> get props => [];
}

class LoadGroups extends GroupManagementEvent {}

class CreateGroupEvent extends GroupManagementEvent {
  final String id;
  final String name;
  final String description;

  const CreateGroupEvent({
    required this.id,
    required this.name,
    required this.description,
  });

  @override
  List<Object> get props => [id, name, description];
}

class UpdateGroupEvent extends GroupManagementEvent {
  final String groupId;
  final String name;
  final String description;

  const UpdateGroupEvent({
    required this.groupId,
    required this.name,
    required this.description,
  });

  @override
  List<Object> get props => [groupId, name, description];
}

class DeleteGroupEvent extends GroupManagementEvent {
  final String groupId;

  const DeleteGroupEvent({required this.groupId});

  @override
  List<Object> get props => [groupId];
}