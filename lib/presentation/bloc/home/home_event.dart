part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadGroups extends HomeEvent {}

class ToggleGroupPower extends HomeEvent {
  final GroupEntity group;

  const ToggleGroupPower({required this.group});

  @override
  List<Object> get props => [group];
}

class UpdateGroupState extends HomeEvent {
  final String groupId;
  final GroupStateEntity newState;

  const UpdateGroupState({
    required this.groupId,
    required this.newState,
  });

  @override
  List<Object> get props => [groupId, newState];
}

class SetGroupColorEvent extends HomeEvent {
  final String groupId;
  final List<int> color;

  const SetGroupColorEvent({
    required this.groupId,
    required this.color,
  });

  @override
  List<Object> get props => [groupId, color];
}

class SetWarmWhiteEvent extends HomeEvent {
  final String groupId;
  final int intensity;

  const SetWarmWhiteEvent({
    required this.groupId,
    required this.intensity,
  });

  @override
  List<Object> get props => [groupId, intensity];
}

class SetColdWhiteEvent extends HomeEvent {
  final String groupId;
  final int intensity;

  const SetColdWhiteEvent({
    required this.groupId,
    required this.intensity,
  });

  @override
  List<Object> get props => [groupId, intensity];
}