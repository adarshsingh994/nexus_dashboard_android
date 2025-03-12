import 'package:equatable/equatable.dart';

class GroupStateEntity extends Equatable {
  final bool isOn;
  final List<int>? rgb;
  final int? warmWhiteIntensity;
  final int? coldWhiteIntensity;

  const GroupStateEntity({
    required this.isOn,
    this.rgb,
    this.warmWhiteIntensity,
    this.coldWhiteIntensity,
  });

  @override
  List<Object?> get props => [
        isOn,
        rgb,
        warmWhiteIntensity,
        coldWhiteIntensity,
      ];

  GroupStateEntity copyWith({
    bool? isOn,
    List<int>? rgb,
    int? warmWhiteIntensity,
    int? coldWhiteIntensity,
  }) {
    return GroupStateEntity(
      isOn: isOn ?? this.isOn,
      rgb: rgb ?? this.rgb,
      warmWhiteIntensity: warmWhiteIntensity ?? this.warmWhiteIntensity,
      coldWhiteIntensity: coldWhiteIntensity ?? this.coldWhiteIntensity,
    );
  }
}