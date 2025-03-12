part of 'group_details_bloc.dart';

abstract class GroupDetailsEvent extends Equatable {
  const GroupDetailsEvent();

  @override
  List<Object> get props => [];
}

class LoadGroupDetails extends GroupDetailsEvent {
  final String groupId;

  const LoadGroupDetails({required this.groupId});

  @override
  List<Object> get props => [groupId];
}

class UpdateGroupDetails extends GroupDetailsEvent {
  final String groupId;
  final String name;
  final String description;

  const UpdateGroupDetails({
    required this.groupId,
    required this.name,
    required this.description,
  });

  @override
  List<Object> get props => [groupId, name, description];
}

class CreateGroupDetails extends GroupDetailsEvent {
  final String groupId;
  final String name;
  final String description;

  const CreateGroupDetails({
    required this.groupId,
    required this.name,
    required this.description,
  });

  @override
  List<Object> get props => [groupId, name, description];
}

class DeleteGroupDetails extends GroupDetailsEvent {
  final String groupId;

  const DeleteGroupDetails({required this.groupId});

  @override
  List<Object> get props => [groupId];
}

class LoadGroupLights extends GroupDetailsEvent {
  final String groupId;

  const LoadGroupLights({required this.groupId});

  @override
  List<Object> get props => [groupId];
}

class AddLightToGroup extends GroupDetailsEvent {
  final String groupId;
  final String lightIp;

  const AddLightToGroup({
    required this.groupId,
    required this.lightIp,
  });

  @override
  List<Object> get props => [groupId, lightIp];
}

class RemoveLightFromGroup extends GroupDetailsEvent {
  final String groupId;
  final String lightIp;

  const RemoveLightFromGroup({
    required this.groupId,
    required this.lightIp,
  });

  @override
  List<Object> get props => [groupId, lightIp];
}