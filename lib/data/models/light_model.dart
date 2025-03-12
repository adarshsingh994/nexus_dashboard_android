import 'package:nexus_dashboard/domain/entities/light_entity.dart';

class LightModel extends LightEntity {
  const LightModel({
    required super.ip,
    required super.name,
    required super.state,
    required super.features,
  });

  factory LightModel.fromJson(Map<String, dynamic> json) {
    return LightModel(
      ip: json['ip'],
      name: json['name'],
      state: LightStateModel.fromJson(json['state']),
      features: LightFeaturesModel.fromJson(json['features']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ip': ip,
      'name': name,
      'state': (state as LightStateModel).toJson(),
      'features': (features as LightFeaturesModel).toJson(),
    };
  }

  @override
  LightModel copyWith({
    String? ip,
    String? name,
    LightStateEntity? state,
    LightFeaturesEntity? features,
  }) {
    return LightModel(
      ip: ip ?? this.ip,
      name: name ?? this.name,
      state: state as LightStateModel? ?? this.state as LightStateModel,
      features: features as LightFeaturesModel? ?? this.features as LightFeaturesModel,
    );
  }
}

class LightStateModel extends LightStateEntity {
  const LightStateModel({
    required super.isOn,
    required super.brightness,
    super.rgb,
  });

  factory LightStateModel.fromJson(Map<String, dynamic> json) {
    // Handle the case where rgb array contains null values
    List<int>? rgbList;
    if (json['rgb'] != null) {
      // Check if any element in the rgb array is null
      bool hasNullValues = (json['rgb'] as List).any((element) => element == null);
      if (hasNullValues) {
        // If there are null values, return null for the entire rgb list
        rgbList = null;
      } else {
        // If all values are non-null, convert to List<int>
        rgbList = List<int>.from(json['rgb']);
      }
    }

    return LightStateModel(
      isOn: json['isOn'] ?? false,
      brightness: json['brightness'] ?? 0,
      rgb: rgbList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isOn': isOn,
      'brightness': brightness,
      'rgb': rgb,
    };
  }

  @override
  LightStateModel copyWith({
    bool? isOn,
    int? brightness,
    List<int>? rgb,
  }) {
    return LightStateModel(
      isOn: isOn ?? this.isOn,
      brightness: brightness ?? this.brightness,
      rgb: rgb ?? this.rgb,
    );
  }
}

class LightFeaturesModel extends LightFeaturesEntity {
  const LightFeaturesModel({
    required super.brightness,
    required super.color,
    required super.colorTemp,
    required super.effect,
  });

  factory LightFeaturesModel.fromJson(Map<String, dynamic> json) {
    return LightFeaturesModel(
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

  @override
  LightFeaturesModel copyWith({
    bool? brightness,
    bool? color,
    bool? colorTemp,
    bool? effect,
  }) {
    return LightFeaturesModel(
      brightness: brightness ?? this.brightness,
      color: color ?? this.color,
      colorTemp: colorTemp ?? this.colorTemp,
      effect: effect ?? this.effect,
    );
  }
}