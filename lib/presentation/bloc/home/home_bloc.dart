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
    
    // Optimistically update the UI
    final updatedGroups = currentState.groups.map((g) {
      if (g.id == group.id) {
        final newState = g.state?.copyWith(isOn: !g.state!.isOn) ?? 
            (g.state?.isOn == true ? g.state?.copyWith(isOn: false) : g.state?.copyWith(isOn: true));
        return g.copyWith(state: newState);
      }
      return g;
    }).toList();
    
    emit(HomeLoaded(groups: updatedGroups));
    
    // Make the API call
    final result = group.state?.isOn == true
        ? await turnOffGroup(TurnOffGroupParams(groupId: group.id))
        : await turnOnGroup(TurnOnGroupParams(groupId: group.id));
    
    result.fold(
      (failure) {
        // Revert to the original state on error
        emit(HomeLoaded(groups: currentState.groups));
        emit(HomeOperationError(message: failure.message));
      },
      (success) {
        // Success, keep the updated state
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