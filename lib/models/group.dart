import 'package:nexus_dashboard/models/group_state.dart';

class Group {
  final String id;
  final String name;
  final String description;
  final List<String> parentGroups;
  final List<String> childGroups;
  final List<String> bulbs;
  final GroupState? state;

  Group({
    required this.id,
    required this.name,
    required this.description,
    required this.parentGroups,
    required this.childGroups,
    required this.bulbs,
    this.state,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    // Handle the case where isOn is directly in the group object
    GroupState? groupState;
    if (json['state'] != null) {
      groupState = GroupState.fromJson(json['state']);
    } else if (json['isOn'] != null) {
      // Create a GroupState from the isOn property
      groupState = GroupState(isOn: json['isOn'] as bool);
    }
    
    return Group(
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
      data['state'] = state!.toJson();
    }
    
    return data;
  }
  
  // Create a copy with updated values
  Group copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? parentGroups,
    List<String>? childGroups,
    List<String>? bulbs,
    GroupState? state,
  }) {
    return Group(
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