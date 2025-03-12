part of 'light_bloc.dart';

abstract class LightState extends Equatable {
  const LightState();
  
  @override
  List<Object> get props => [];
}

class LightInitial extends LightState {}

class LightLoading extends LightState {}

class LightLoaded extends LightState {
  final List<LightEntity> lights;

  const LightLoaded({required this.lights});

  @override
  List<Object> get props => [lights];
}

class UngroupedLightsLoaded extends LightState {
  final List<LightEntity> lights;

  const UngroupedLightsLoaded({required this.lights});

  @override
  List<Object> get props => [lights];
}

class LightError extends LightState {
  final String message;

  const LightError({required this.message});

  @override
  List<Object> get props => [message];
}