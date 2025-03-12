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