part of 'group_details_bloc.dart';

abstract class GroupDetailsState extends Equatable {
  const GroupDetailsState();
  
  @override
  List<Object> get props => [];
}

class GroupDetailsInitial extends GroupDetailsState {}

class GroupDetailsLoading extends GroupDetailsState {}

class GroupDetailsLoaded extends GroupDetailsState {
  final GroupEntity group;

  const GroupDetailsLoaded({required this.group});

  @override
  List<Object> get props => [group];
}

class GroupDetailsError extends GroupDetailsState {
  final String message;

  const GroupDetailsError({required this.message});

  @override
  List<Object> get props => [message];
}

class GroupDetailsOperationLoading extends GroupDetailsState {}

class GroupDetailsOperationSuccess extends GroupDetailsState {
  final String message;

  const GroupDetailsOperationSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class GroupDetailsOperationError extends GroupDetailsState {
  final String message;

  const GroupDetailsOperationError({required this.message});

  @override
  List<Object> get props => [message];
}

class GroupDetailsDeleted extends GroupDetailsState {
  final String message;

  const GroupDetailsDeleted({required this.message});

  @override
  List<Object> get props => [message];
}

class GroupLightsLoading extends GroupDetailsState {
  final GroupEntity group;

  const GroupLightsLoading({required this.group});

  @override
  List<Object> get props => [group];
}

class GroupLightsLoaded extends GroupDetailsState {
  final GroupEntity group;
  final List<LightEntity> groupLights;
  final List<LightEntity> ungroupedLights;

  const GroupLightsLoaded({
    required this.group,
    required this.groupLights,
    required this.ungroupedLights,
  });

  @override
  List<Object> get props => [group, groupLights, ungroupedLights];
}

class GroupLightsError extends GroupDetailsState {
  final GroupEntity group;
  final String message;

  const GroupLightsError({
    required this.group,
    required this.message,
  });

  @override
  List<Object> get props => [group, message];
}

class GroupLightsOperationError extends GroupDetailsState {
  final GroupEntity group;
  final List<LightEntity> groupLights;
  final List<LightEntity> ungroupedLights;
  final String message;

  const GroupLightsOperationError({
    required this.group,
    required this.groupLights,
    required this.ungroupedLights,
    required this.message,
  });

  @override
  List<Object> get props => [group, groupLights, ungroupedLights, message];
}