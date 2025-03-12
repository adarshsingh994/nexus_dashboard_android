class Light {
  final String ip;
  final String name;
  final LightState state;
  final LightFeatures features;

  Light({
    required this.ip,
    required this.name,
    required this.state,
    required this.features,
  });

  factory Light.fromJson(Map<String, dynamic> json) {
    return Light(
      ip: json['ip'],
      name: json['name'],
      state: LightState.fromJson(json['state']),
      features: LightFeatures.fromJson(json['features']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ip': ip,
      'name': name,
      'state': state.toJson(),
      'features': features.toJson(),
    };
  }
}

class LightState {
  final bool isOn;
  final int brightness;
  final List<int>? rgb;

  LightState({
    required this.isOn,
    required this.brightness,
    this.rgb,
  });

  factory LightState.fromJson(Map<String, dynamic> json) {
    return LightState(
      isOn: json['isOn'] ?? false,
      brightness: json['brightness'] ?? 0,
      rgb: json['rgb'] != null ? List<int>.from(json['rgb']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isOn': isOn,
      'brightness': brightness,
      'rgb': rgb,
    };
  }
}

class LightFeatures {
  final bool brightness;
  final bool color;
  final bool colorTemp;
  final bool effect;

  LightFeatures({
    required this.brightness,
    required this.color,
    required this.colorTemp,
    required this.effect,
  });

  factory LightFeatures.fromJson(Map<String, dynamic> json) {
    return LightFeatures(
      brightness: json['brightness'] ?? false,
      color: json['color'] ?? false,
      colorTemp: json['color_tmp'] ?? false,
      effect: json['effect'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'brightness': brightness,
      'color': color,
      'color_tmp': colorTemp,
      'effect': effect,
    };
  }
}