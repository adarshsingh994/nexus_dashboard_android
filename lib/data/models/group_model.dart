import 'package:nexus_dashboard/data/models/group_state_model.dart';
import 'package:nexus_dashboard/domain/entities/group_entity.dart';
import 'package:nexus_dashboard/domain/entities/group_state_entity.dart';

class GroupModel extends GroupEntity {
  const GroupModel({
    required super.id,
    required super.name,
    required super.description,
    required super.parentGroups,
    required super.childGroups,
    required super.bulbs,
    super.state,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    // Handle the case where isOn is directly in the group object
    GroupStateModel? groupState;
    if (json['state'] != null) {
      groupState = GroupStateModel.fromJson(json['state']);
    } else if (json['isOn'] != null) {
      // Create a GroupState from the isOn property
      groupState = GroupStateModel(isOn: json['isOn'] as bool);
    }
    
    return GroupModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      parentGroups: json['parentGroups'] is Map
          ? [] // Return empty list if it's a Map
          : List<String>.from(json['parentGroups'] ?? []),
      childGroups: json['childGroups'] is Map
          ? [] // Return empty list if it's a Map
          : List<String>.from(json['childGroups'] ?? []),
      bulbs: json['bulbs'] is Map
          ? [] // Return empty list if it's a Map
          : List<String>.from(json['bulbs'] ?? []),
      state: groupState,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'name': name,
      'description': description,
      'parentGroups': parentGroups,
      'childGroups': childGroups,
      'bulbs': bulbs,
    };
    
    // Include isOn directly in the group object if state is not null
    if (state != null) {
      data['isOn'] = state!.isOn;
      
      // Also include the full state object for backward compatibility
      if (state is GroupStateModel) {
        data['state'] = (state as GroupStateModel).toJson();
      }
    }
    
    return data;
  }
  
  // Create a copy with updated values
  @override
  GroupModel copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? parentGroups,
    List<String>? childGroups,
    List<String>? bulbs,
    dynamic state,
  }) {
    return GroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      parentGroups: parentGroups ?? this.parentGroups,
      childGroups: childGroups ?? this.childGroups,
      bulbs: bulbs ?? this.bulbs,
      state: state != null
          ? (state is GroupStateModel
              ? state
              : (state is GroupStateEntity
                  ? GroupStateModel(
                      isOn: state.isOn,
                      rgb: state.rgb,
                      warmWhiteIntensity: state.warmWhiteIntensity,
                      coldWhiteIntensity: state.coldWhiteIntensity,
                    )
                  : null))
          : (this.state != null
              ? (this.state is GroupStateModel
                  ? this.state as GroupStateModel
                  : GroupStateModel(
                      isOn: this.state!.isOn,
                      rgb: this.state!.rgb,
                      warmWhiteIntensity: this.state!.warmWhiteIntensity,
                      coldWhiteIntensity: this.state!.coldWhiteIntensity,
                    ))
              : null),
    );
  }
}