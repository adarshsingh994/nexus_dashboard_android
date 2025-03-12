class GroupState {
  final bool isOn;
  final List<int>? rgb;
  final int? warmWhiteIntensity;
  final int? coldWhiteIntensity;

  GroupState({
    required this.isOn,
    this.rgb,
    this.warmWhiteIntensity,
    this.coldWhiteIntensity,
  });

  factory GroupState.fromJson(Map<String, dynamic> json) {
    return GroupState(
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
  GroupState copyWith({
    bool? isOn,
    List<int>? rgb,
    int? warmWhiteIntensity,
    int? coldWhiteIntensity,
  }) {
    return GroupState(
      isOn: isOn ?? this.isOn,
      rgb: rgb ?? this.rgb,
      warmWhiteIntensity: warmWhiteIntensity ?? this.warmWhiteIntensity,
      coldWhiteIntensity: coldWhiteIntensity ?? this.coldWhiteIntensity,
    );
  }
}