import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus_dashboard/domain/entities/group_entity.dart';
import 'package:nexus_dashboard/domain/entities/group_state_entity.dart';
import 'package:nexus_dashboard/domain/usecases/group/get_groups.dart';
import 'package:nexus_dashboard/domain/usecases/group/toggle_group_power.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetGroups getGroups;
  final TurnOnGroup turnOnGroup;
  final TurnOffGroup turnOffGroup;

  HomeBloc({
    required this.getGroups,
    required this.turnOnGroup,
    required this.turnOffGroup,
  }) : super(HomeInitial()) {
    on<LoadGroups>(_onLoadGroups);
    on<ToggleGroupPower>(_onToggleGroupPower);
    on<UpdateGroupState>(_onUpdateGroupState);
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
  }
}