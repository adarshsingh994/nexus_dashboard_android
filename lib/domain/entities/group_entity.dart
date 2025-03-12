import 'package:equatable/equatable.dart';
import 'package:nexus_dashboard/domain/entities/group_state_entity.dart';

class GroupEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<String> parentGroups;
  final List<String> childGroups;
  final List<String> bulbs;
  final GroupStateEntity? state;

  const GroupEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.parentGroups,
    required this.childGroups,
    required this.bulbs,
    this.state,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        parentGroups,
        childGroups,
        bulbs,
        state,
      ];

  GroupEntity copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? parentGroups,
    List<String>? childGroups,
    List<String>? bulbs,
    GroupStateEntity? state,
  }) {
    return GroupEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      parentGroups: parentGroups ?? this.parentGroups,
      childGroups: childGroups ?? this.childGroups,
      bulbs: bulbs ?? this.bulbs,
      state: state ?? this.state,
    );
  }
}