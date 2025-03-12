import 'package:nexus_dashboard/domain/entities/group_state_entity.dart';

class GroupStateModel extends GroupStateEntity {
  const GroupStateModel({
    required super.isOn,
    super.rgb,
    super.warmWhiteIntensity,
    super.coldWhiteIntensity,
  });

  factory GroupStateModel.fromJson(Map<String, dynamic> json) {
    return GroupStateModel(
      isOn: json['isOn'] ?? false,
      rgb: json['rgb'] != null ? List<int>.from(json['rgb']) : null,
      warmWhiteIntensity: json['warmWhiteIntensity'],
      coldWhiteIntensity: json['coldWhiteIntensity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isOn': isOn,
      'rgb': rgb,
      'warmWhiteIntensity': warmWhiteIntensity,
      'coldWhiteIntensity': coldWhiteIntensity,
    };
  }

  // Create a copy with updated values
  @override
  GroupStateModel copyWith({
    bool? isOn,
    List<int>? rgb,
    int? warmWhiteIntensity,
    int? coldWhiteIntensity,
  }) {
    return GroupStateModel(
      isOn: isOn ?? this.isOn,
      rgb: rgb ?? this.rgb,
      warmWhiteIntensity: warmWhiteIntensity ?? this.warmWhiteIntensity,
      coldWhiteIntensity: coldWhiteIntensity ?? this.coldWhiteIntensity,
    );
  }
}