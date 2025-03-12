part of 'group_bloc.dart';

abstract class GroupEvent extends Equatable {
  const GroupEvent();

  @override
  List<Object> get props => [];
}

class LoadGroup extends GroupEvent {
  final String groupId;

  const LoadGroup({required this.groupId});

  @override
  List<Object> get props => [groupId];
}

class TogglePower extends GroupEvent {
  final String groupId;

  const TogglePower({required this.groupId});

  @override
  List<Object> get props => [groupId];
}

class SetColorEvent extends GroupEvent {
  final String groupId;
  final List<int> color;

  const SetColorEvent({
    required this.groupId,
    required this.color,
  });

  @override
  List<Object> get props => [groupId, color];
}

class SetWarmWhiteEvent extends GroupEvent {
  final String groupId;
  final int intensity;

  const SetWarmWhiteEvent({
    required this.groupId,
    required this.intensity,
  });

  @override
  List<Object> get props => [groupId, intensity];
}

class SetColdWhiteEvent extends GroupEvent {
  final String groupId;
  final int intensity;

  const SetColdWhiteEvent({
    required this.groupId,
    required this.intensity,
  });

  @override
  List<Object> get props => [groupId, intensity];
}