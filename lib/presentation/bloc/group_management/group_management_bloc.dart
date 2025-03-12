import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus_dashboard/domain/entities/group_entity.dart';
import 'package:nexus_dashboard/domain/usecases/group/create_group.dart';
import 'package:nexus_dashboard/domain/usecases/group/delete_group.dart';
import 'package:nexus_dashboard/domain/usecases/group/get_groups.dart';
import 'package:nexus_dashboard/domain/usecases/group/update_group.dart';

part 'group_management_event.dart';
part 'group_management_state.dart';

class GroupManagementBloc extends Bloc<GroupManagementEvent, GroupManagementState> {
  final GetGroups getGroups;
  final CreateGroup createGroup;
  final UpdateGroup updateGroup;
  final DeleteGroup deleteGroup;

  GroupManagementBloc({
    required this.getGroups,
    required this.createGroup,
    required this.updateGroup,
    required this.deleteGroup,
  }) : super(GroupManagementInitial()) {
    on<LoadGroups>(_onLoadGroups);
    on<CreateGroupEvent>(_onCreateGroup);
    on<UpdateGroupEvent>(_onUpdateGroup);
    on<DeleteGroupEvent>(_onDeleteGroup);
  }

  Future<void> _onLoadGroups(LoadGroups event, Emitter<GroupManagementState> emit) async {
    emit(GroupManagementLoading());
    
    final result = await getGroups();
    
    result.fold(
      (failure) => emit(GroupManagementError(message: failure.message)),
      (groups) => emit(GroupManagementLoaded(groups: groups)),
    );
  }

  Future<void> _onCreateGroup(CreateGroupEvent event, Emitter<GroupManagementState> emit) async {
    emit(GroupManagementOperationLoading());
    
    final result = await createGroup(
      CreateGroupParams(
        id: event.id,
        name: event.name,
        description: event.description,
      ),
    );
    
    result.fold(
      (failure) => emit(GroupManagementOperationError(message: failure.message)),
      (group) {
        emit(GroupManagementOperationSuccess(message: 'Group created successfully'));
        add(LoadGroups()); // Reload the groups list
      },
    );
  }

  Future<void> _onUpdateGroup(UpdateGroupEvent event, Emitter<GroupManagementState> emit) async {
    emit(GroupManagementOperationLoading());
    
    final result = await updateGroup(
      UpdateGroupParams(
        groupId: event.groupId,
        name: event.name,
        description: event.description,
      ),
    );
    
    result.fold(
      (failure) => emit(GroupManagementOperationError(message: failure.message)),
      (group) {
        emit(GroupManagementOperationSuccess(message: 'Group updated successfully'));
        add(LoadGroups()); // Reload the groups list
      },
    );
  }

  Future<void> _onDeleteGroup(DeleteGroupEvent event, Emitter<GroupManagementState> emit) async {
    emit(GroupManagementOperationLoading());
    
    final result = await deleteGroup(
      DeleteGroupParams(groupId: event.groupId),
    );
    
    result.fold(
      (failure) => emit(GroupManagementOperationError(message: failure.message)),
      (success) {
        emit(GroupManagementOperationSuccess(message: 'Group deleted successfully'));
        add(LoadGroups()); // Reload the groups list
      },
    );
  }
}