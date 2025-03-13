import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus_dashboard/domain/entities/group_entity.dart';
import 'package:nexus_dashboard/domain/entities/group_state_entity.dart';
import 'package:nexus_dashboard/domain/usecases/group/get_groups.dart';
import 'package:nexus_dashboard/domain/usecases/group/set_group_color.dart';
import 'package:nexus_dashboard/domain/usecases/group/set_white_intensity.dart';
import 'package:nexus_dashboard/domain/usecases/group/toggle_group_power.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetGroups getGroups;
  final TurnOnGroup turnOnGroup;
  final TurnOffGroup turnOffGroup;
  final SetGroupColor setColor;
  final SetWarmWhite setWarmWhite;
  final SetColdWhite setColdWhite;

  HomeBloc({
    required this.getGroups,
    required this.turnOnGroup,
    required this.turnOffGroup,
    required this.setColor,
    required this.setWarmWhite,
    required this.setColdWhite,
  }) : super(HomeInitial()) {
    on<LoadGroups>(_onLoadGroups);
    on<ToggleGroupPower>(_onToggleGroupPower);
    on<UpdateGroupState>(_onUpdateGroupState);
    on<SetGroupColorEvent>(_onSetGroupColor);
    on<SetWarmWhiteEvent>(_onSetWarmWhite);
    on<SetColdWhiteEvent>(_onSetColdWhite);
  }

  Future<void> _onLoadGroups(LoadGroups event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    
    final result = await getGroups();
    
    result.fold(
      (failure) => emit(HomeError(message: failure.message)),
      (groups) => emit(HomeLoaded(groups: groups)),
    );
  }

  Future<void> _onToggleGroupPower(ToggleGroupPower event, Emitter<HomeState> emit) async {
    if (state is! HomeLoaded) return;
    
    final currentState = state as HomeLoaded;
    final group = event.group;
    
    // Don't optimistically update the UI anymore, just show loading state
    // The GroupCard will handle showing the loading indicator
    
    // Make the API call
    final result = group.state?.isOn == true
        ? await turnOffGroup(TurnOffGroupParams(groupId: group.id))
        : await turnOnGroup(TurnOnGroupParams(groupId: group.id));
    
    result.fold(
      (failure) {
        // Show error message
        emit(HomeOperationError(message: failure.message));
      },
      (success) {
        // Check for overall_success parameter
        bool overallSuccess = success['overall_success'] == true;
        
        // Update the UI based on the API response
        final updatedGroups = currentState.groups.map((g) {
          if (g.id == group.id && overallSuccess) {
            // Only update the state if overall_success is true
            final newState = g.state?.copyWith(isOn: !g.state!.isOn) ??
                (g.state?.isOn == true ? g.state?.copyWith(isOn: false) : g.state?.copyWith(isOn: true));
            return g.copyWith(state: newState);
          }
          return g;
        }).toList();
        
        emit(HomeLoaded(groups: updatedGroups));
      },
    );
  }

  void _onUpdateGroupState(UpdateGroupState event, Emitter<HomeState> emit) {
    if (state is! HomeLoaded) return;
    
    final currentState = state as HomeLoaded;
    
    final updatedGroups = currentState.groups.map((g) {
      if (g.id == event.groupId) {
        return g.copyWith(state: event.newState);
      }
      return g;
    }).toList();
    
    emit(HomeLoaded(groups: updatedGroups));
    
    // Check if RGB values have changed and make API call if needed
    if (event.newState.rgb != null) {
      add(SetGroupColorEvent(
        groupId: event.groupId,
        color: event.newState.rgb!,
      ));
    }
    
    // Check if warm white intensity has changed and make API call if needed
    if (event.newState.warmWhiteIntensity != null) {
      add(SetWarmWhiteEvent(
        groupId: event.groupId,
        intensity: event.newState.warmWhiteIntensity!,
      ));
    }
    
    // Check if cold white intensity has changed and make API call if needed
    if (event.newState.coldWhiteIntensity != null) {
      add(SetColdWhiteEvent(
        groupId: event.groupId,
        intensity: event.newState.coldWhiteIntensity!,
      ));
    }
  }
  
  Future<void> _onSetGroupColor(SetGroupColorEvent event, Emitter<HomeState> emit) async {
    if (state is! HomeLoaded) return;
    
    final currentState = state as HomeLoaded;
    
    // Make the API call
    final result = await setColor(
      SetGroupColorParams(groupId: event.groupId, color: event.color),
    );
    
    result.fold(
      (failure) {
        // Show error message
        emit(HomeOperationError(message: failure.message));
        // Emit the current state again to maintain UI consistency
        emit(currentState);
      },
      (success) {
        // Success, no need to update UI as it's already updated optimistically
      },
    );
  }
  
  Future<void> _onSetWarmWhite(SetWarmWhiteEvent event, Emitter<HomeState> emit) async {
    if (state is! HomeLoaded) return;
    
    final currentState = state as HomeLoaded;
    
    // Make the API call
    final result = await setWarmWhite(
      SetWarmWhiteParams(groupId: event.groupId, intensity: event.intensity),
    );
    
    result.fold(
      (failure) {
        // Show error message
        emit(HomeOperationError(message: failure.message));
        // Emit the current state again to maintain UI consistency
        emit(currentState);
      },
      (success) {
        // Success, no need to update UI as it's already updated optimistically
      },
    );
  }
  
  Future<void> _onSetColdWhite(SetColdWhiteEvent event, Emitter<HomeState> emit) async {
    if (state is! HomeLoaded) return;
    
    final currentState = state as HomeLoaded;
    
    // Make the API call
    final result = await setColdWhite(
      SetColdWhiteParams(groupId: event.groupId, intensity: event.intensity),
    );
    
    result.fold(
      (failure) {
        // Show error message
        emit(HomeOperationError(message: failure.message));
        // Emit the current state again to maintain UI consistency
        emit(currentState);
      },
      (success) {
        // Success, no need to update UI as it's already updated optimistically
      },
    );
  }
}