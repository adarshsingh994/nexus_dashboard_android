import 'package:equatable/equatable.dart';

class LightEntity extends Equatable {
  final String ip;
  final String name;
  final LightStateEntity state;
  final LightFeaturesEntity features;

  const LightEntity({
    required this.ip,
    required this.name,
    required this.state,
    required this.features,
  });

  @override
  List<Object> get props => [ip, name, state, features];

  LightEntity copyWith({
    String? ip,
    String? name,
    LightStateEntity? state,
    LightFeaturesEntity? features,
  }) {
    return LightEntity(
      ip: ip ?? this.ip,
      name: name ?? this.name,
      state: state ?? this.state,
      features: features ?? this.features,
    );
  }
}

class LightStateEntity extends Equatable {
  final bool isOn;
  final int brightness;
  final List<int>? rgb;

  const LightStateEntity({
    required this.isOn,
    required this.brightness,
    this.rgb,
  });

  @override
  List<Object?> get props => [isOn, brightness, rgb];

  LightStateEntity copyWith({
    bool? isOn,
    int? brightness,
    List<int>? rgb,
  }) {
    return LightStateEntity(
      isOn: isOn ?? this.isOn,
      brightness: brightness ?? this.brightness,
      rgb: rgb ?? this.rgb,
    );
  }
}

class LightFeaturesEntity extends Equatable {
  final bool brightness;
  final bool color;
  final bool colorTemp;
  final bool effect;

  const LightFeaturesEntity({
    required this.brightness,
    required this.color,
    required this.colorTemp,
    required this.effect,
  });

  @override
  List<Object> get props => [brightness, color, colorTemp, effect];

  LightFeaturesEntity copyWith({
    bool? brightness,
    bool? color,
    bool? colorTemp,
    bool? effect,
  }) {
    return LightFeaturesEntity(
      brightness: brightness ?? this.brightness,
      color: color ?? this.color,
      colorTemp: colorTemp ?? this.colorTemp,
      effect: effect ?? this.effect,
    );
  }
}