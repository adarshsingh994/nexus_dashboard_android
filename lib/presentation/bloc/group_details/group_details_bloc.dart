import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus_dashboard/domain/entities/group_entity.dart';
import 'package:nexus_dashboard/domain/entities/light_entity.dart';
import 'package:nexus_dashboard/domain/usecases/group/create_group.dart';
import 'package:nexus_dashboard/domain/usecases/group/delete_group.dart';
import 'package:nexus_dashboard/domain/usecases/group/get_group_by_id.dart';
import 'package:nexus_dashboard/domain/usecases/group/update_group.dart';
import 'package:nexus_dashboard/domain/usecases/light/get_lights.dart';
import 'package:nexus_dashboard/domain/usecases/light/manage_group_members.dart';

part 'group_details_event.dart';
part 'group_details_state.dart';

class GroupDetailsBloc extends Bloc<GroupDetailsEvent, GroupDetailsState> {
  final GetGroupById getGroupById;
  final CreateGroup createGroup;
  final UpdateGroup updateGroup;
  final DeleteGroup deleteGroup;
  final GetGroupMembers getGroupMembers;
  final GetUngroupedLights getUngroupedLights;
  final AddBulbToGroup addBulbToGroup;
  final RemoveBulbFromGroup removeBulbFromGroup;

  GroupDetailsBloc({
    required this.getGroupById,
    required this.createGroup,
    required this.updateGroup,
    required this.deleteGroup,
    required this.getGroupMembers,
    required this.getUngroupedLights,
    required this.addBulbToGroup,
    required this.removeBulbFromGroup,
  }) : super(GroupDetailsInitial()) {
    on<LoadGroupDetails>(_onLoadGroupDetails);
    on<UpdateGroupDetails>(_onUpdateGroupDetails);
    on<CreateGroupDetails>(_onCreateGroupDetails);
    on<DeleteGroupDetails>(_onDeleteGroupDetails);
    on<LoadGroupLights>(_onLoadGroupLights);
    on<AddLightToGroup>(_onAddLightToGroup);
    on<RemoveLightFromGroup>(_onRemoveLightFromGroup);
  }

  Future<void> _onLoadGroupDetails(LoadGroupDetails event, Emitter<GroupDetailsState> emit) async {
    emit(GroupDetailsLoading());
    
    final result = await getGroupById(GetGroupByIdParams(groupId: event.groupId));
    
    result.fold(
      (failure) => emit(GroupDetailsError(message: failure.message)),
      (group) => emit(GroupDetailsLoaded(group: group)),
    );
  }

  Future<void> _onUpdateGroupDetails(UpdateGroupDetails event, Emitter<GroupDetailsState> emit) async {
    print('DEBUG: Updating group with ID: ${event.groupId}');
    
    emit(GroupDetailsOperationLoading());
    
    final result = await updateGroup(
      UpdateGroupParams(
        groupId: event.groupId,
        name: event.name,
        description: event.description,
      ),
    );
    
    result.fold(
      (failure) => emit(GroupDetailsOperationError(message: failure.message)),
      (group) {
        emit(GroupDetailsOperationSuccess(message: 'Group updated successfully'));
        emit(GroupDetailsLoaded(group: group));
      },
    );
  }

  Future<void> _onCreateGroupDetails(CreateGroupDetails event, Emitter<GroupDetailsState> emit) async {
    print('DEBUG: Creating new group with ID: ${event.groupId}');
    
    emit(GroupDetailsOperationLoading());
    
    final result = await createGroup(
      CreateGroupParams(
        id: event.groupId,
        name: event.name,
        description: event.description,
      ),
    );
    
    result.fold(
      (failure) => emit(GroupDetailsOperationError(message: failure.message)),
      (group) {
        emit(GroupDetailsOperationSuccess(message: 'Group created successfully'));
        emit(GroupDetailsLoaded(group: group));
      },
    );
  }

  Future<void> _onDeleteGroupDetails(DeleteGroupDetails event, Emitter<GroupDetailsState> emit) async {
    emit(GroupDetailsOperationLoading());
    
    final result = await deleteGroup(
      DeleteGroupParams(groupId: event.groupId),
    );
    
    result.fold(
      (failure) => emit(GroupDetailsOperationError(message: failure.message)),
      (success) => emit(GroupDetailsDeleted(message: 'Group deleted successfully')),
    );
  }

  Future<void> _onLoadGroupLights(LoadGroupLights event, Emitter<GroupDetailsState> emit) async {
    if (state is! GroupDetailsLoaded) {
      print('DEBUG: Cannot load lights - state is not GroupDetailsLoaded');
      return;
    }
    
    final currentState = state as GroupDetailsLoaded;
    
    print('DEBUG: Loading lights for group ${event.groupId}');
    emit(GroupLightsLoading(group: currentState.group));
    
    // Get group members
    print('DEBUG: Fetching group members...');
    final membersResult = await getGroupMembers(
      GetGroupMembersParams(groupId: event.groupId),
    );
    
    // Get ungrouped lights
    print('DEBUG: Fetching ungrouped lights...');
    final ungroupedResult = await getUngroupedLights();
    
    // Log results
    membersResult.fold(
      (failure) => print('DEBUG: Group members fetch failed: ${failure.message}'),
      (lights) => print('DEBUG: Group members fetch succeeded: ${lights.length} lights found'),
    );
    
    ungroupedResult.fold(
      (failure) => print('DEBUG: Ungrouped lights fetch failed: ${failure.message}'),
      (lights) => print('DEBUG: Ungrouped lights fetch succeeded: ${lights.length} lights found'),
    );
    
    // Handle both results
    if (membersResult.isLeft() || ungroupedResult.isLeft()) {
      // At least one failed
      final message = membersResult.fold(
        (failure) => failure.message,
        (_) => ungroupedResult.fold(
          (failure) => failure.message,
          (_) => 'Unknown error',
        ),
      );
      
      print('DEBUG: Emitting GroupLightsError: $message');
      emit(GroupLightsError(
        group: currentState.group,
        message: message,
      ));
      return;
    }
    
    // Both succeeded
    final groupLights = membersResult.getOrElse(() => []);
    final ungroupedLights = ungroupedResult.getOrElse(() => []);
    
    print('DEBUG: Emitting GroupLightsLoaded with ${groupLights.length} group lights and ${ungroupedLights.length} ungrouped lights');
    emit(GroupLightsLoaded(
      group: currentState.group,
      groupLights: groupLights,
      ungroupedLights: ungroupedLights,
    ));
  }

  Future<void> _onAddLightToGroup(AddLightToGroup event, Emitter<GroupDetailsState> emit) async {
    if (state is! GroupLightsLoaded) return;
    
    final currentState = state as GroupLightsLoaded;
    
    // Optimistically update UI
    final updatedUngroupedLights = currentState.ungroupedLights
        .where((light) => light.ip != event.lightIp)
        .toList();
    
    final lightToAdd = currentState.ungroupedLights
        .firstWhere((light) => light.ip == event.lightIp);
    
    final updatedGroupLights = [...currentState.groupLights, lightToAdd];
    
    emit(GroupLightsLoaded(
      group: currentState.group,
      groupLights: updatedGroupLights,
      ungroupedLights: updatedUngroupedLights,
    ));
    
    // Make API call
    final result = await addBulbToGroup(
      AddBulbToGroupParams(
        groupId: event.groupId,
        bulbIp: event.lightIp,
      ),
    );
    
    result.fold(
      (failure) {
        // Revert to original state on error
        emit(GroupLightsLoaded(
          group: currentState.group,
          groupLights: currentState.groupLights,
          ungroupedLights: currentState.ungroupedLights,
        ));
        emit(GroupLightsOperationError(
          group: currentState.group,
          groupLights: currentState.groupLights,
          ungroupedLights: currentState.ungroupedLights,
          message: failure.message,
        ));
      },
      (success) {
        // Success, keep updated state
      },
    );
  }

  Future<void> _onRemoveLightFromGroup(RemoveLightFromGroup event, Emitter<GroupDetailsState> emit) async {
    if (state is! GroupLightsLoaded) return;
    
    final currentState = state as GroupLightsLoaded;
    
    // Optimistically update UI
    final updatedGroupLights = currentState.groupLights
        .where((light) => light.ip != event.lightIp)
        .toList();
    
    final lightToRemove = currentState.groupLights
        .firstWhere((light) => light.ip == event.lightIp);
    
    final updatedUngroupedLights = [...currentState.ungroupedLights, lightToRemove];
    
    emit(GroupLightsLoaded(
      group: currentState.group,
      groupLights: updatedGroupLights,
      ungroupedLights: updatedUngroupedLights,
    ));
    
    // Make API call
    final result = await removeBulbFromGroup(
      RemoveBulbFromGroupParams(
        groupId: event.groupId,
        bulbIp: event.lightIp,
      ),
    );
    
    result.fold(
      (failure) {
        // Revert to original state on error
        emit(GroupLightsLoaded(
          group: currentState.group,
          groupLights: currentState.groupLights,
          ungroupedLights: currentState.ungroupedLights,
        ));
        emit(GroupLightsOperationError(
          group: currentState.group,
          groupLights: currentState.groupLights,
          ungroupedLights: currentState.ungroupedLights,
          message: failure.message,
        ));
      },
      (success) {
        // Success, keep updated state
      },
    );
  }
}