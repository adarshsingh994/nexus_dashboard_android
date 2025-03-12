import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus_dashboard/domain/entities/group_entity.dart';
import 'package:nexus_dashboard/domain/entities/group_state_entity.dart';
import 'package:nexus_dashboard/domain/usecases/group/get_group_by_id.dart';
import 'package:nexus_dashboard/domain/usecases/group/get_groups.dart';
import 'package:nexus_dashboard/domain/usecases/group/set_group_color.dart';
import 'package:nexus_dashboard/domain/usecases/group/set_white_intensity.dart';
import 'package:nexus_dashboard/domain/usecases/group/toggle_group_power.dart';

part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final GetGroups getGroups;
  final GetGroupById getGroupById;
  final TurnOnGroup turnOnGroup;
  final TurnOffGroup turnOffGroup;
  final SetGroupColor setColor;
  final SetWarmWhite setWarmWhite;
  final SetColdWhite setColdWhite;

  GroupBloc({
    required this.getGroups,
    required this.getGroupById,
    required this.turnOnGroup,
    required this.turnOffGroup,
    required this.setColor,
    required this.setWarmWhite,
    required this.setColdWhite,
  }) : super(GroupInitial()) {
    on<LoadGroup>(_onLoadGroup);
    on<TogglePower>(_onTogglePower);
    on<SetColorEvent>(_onSetColor);
    on<SetWarmWhiteEvent>(_onSetWarmWhite);
    on<SetColdWhiteEvent>(_onSetColdWhite);
  }

  Future<void> _onLoadGroup(LoadGroup event, Emitter<GroupState> emit) async {
    emit(GroupLoading());
    
    final result = await getGroupById(GetGroupByIdParams(groupId: event.groupId));
    
    result.fold(
      (failure) => emit(GroupError(message: failure.message)),
      (group) => emit(GroupLoaded(group: group)),
    );
  }

  Future<void> _onTogglePower(TogglePower event, Emitter<GroupState> emit) async {
    if (state is! GroupLoaded) return;
    
    final currentState = state as GroupLoaded;
    final group = currentState.group;
    
    // Optimistically update the UI
    final isCurrentlyOn = group.state?.isOn ?? false;
    final updatedGroup = group.copyWith(
      state: group.state?.copyWith(isOn: !isCurrentlyOn) ??
          GroupStateEntity(isOn: !isCurrentlyOn),
    );
    
    emit(GroupLoaded(group: updatedGroup));
    
    // Make the API call
    final result = isCurrentlyOn
        ? await turnOffGroup(TurnOffGroupParams(groupId: group.id))
        : await turnOnGroup(TurnOnGroupParams(groupId: group.id));
    
    result.fold(
      (failure) {
        // Revert to the original state on error
        emit(GroupLoaded(group: group));
        emit(GroupOperationError(message: failure.message));
      },
      (success) {
        // Success, keep the updated state
      },
    );
  }

  Future<void> _onSetColor(SetColorEvent event, Emitter<GroupState> emit) async {
    if (state is! GroupLoaded) return;
    
    final currentState = state as GroupLoaded;
    final group = currentState.group;
    
    // Optimistically update the UI
    final updatedGroup = group.copyWith(
      state: group.state?.copyWith(
        isOn: true, // Setting color implies turning on
        rgb: event.color,
      ) ??
      GroupStateEntity(
        isOn: true,
        rgb: event.color,
      ),
    );
    
    emit(GroupLoaded(group: updatedGroup));
    
    // Make the API call
    final result = await setColor(
      SetGroupColorParams(groupId: group.id, color: event.color),
    );
    
    result.fold(
      (failure) {
        // Revert to the original state on error
        emit(GroupLoaded(group: group));
        emit(GroupOperationError(message: failure.message));
      },
      (success) {
        // Success, keep the updated state
      },
    );
  }

  Future<void> _onSetWarmWhite(SetWarmWhiteEvent event, Emitter<GroupState> emit) async {
    if (state is! GroupLoaded) return;
    
    final currentState = state as GroupLoaded;
    final group = currentState.group;
    
    // Optimistically update the UI
    final updatedGroup = group.copyWith(
      state: group.state?.copyWith(
        isOn: true, // Setting white implies turning on
        warmWhiteIntensity: event.intensity,
      ) ??
      GroupStateEntity(
        isOn: true,
        warmWhiteIntensity: event.intensity,
      ),
    );
    
    emit(GroupLoaded(group: updatedGroup));
    
    // Make the API call
    final result = await setWarmWhite(
      SetWarmWhiteParams(groupId: group.id, intensity: event.intensity),
    );
    
    result.fold(
      (failure) {
        // Revert to the original state on error
        emit(GroupLoaded(group: group));
        emit(GroupOperationError(message: failure.message));
      },
      (success) {
        // Success, keep the updated state
      },
    );
  }

  Future<void> _onSetColdWhite(SetColdWhiteEvent event, Emitter<GroupState> emit) async {
    if (state is! GroupLoaded) return;
    
    final currentState = state as GroupLoaded;
    final group = currentState.group;
    
    // Optimistically update the UI
    final updatedGroup = group.copyWith(
      state: group.state?.copyWith(
        isOn: true, // Setting white implies turning on
        coldWhiteIntensity: event.intensity,
      ) ??
      GroupStateEntity(
        isOn: true,
        coldWhiteIntensity: event.intensity,
      ),
    );
    
    emit(GroupLoaded(group: updatedGroup));
    
    // Make the API call
    final result = await setColdWhite(
      SetColdWhiteParams(groupId: group.id, intensity: event.intensity),
    );
    
    result.fold(
      (failure) {
        // Revert to the original state on error
        emit(GroupLoaded(group: group));
        emit(GroupOperationError(message: failure.message));
      },
      (success) {
        // Success, keep the updated state
      },
    );
  }
}