part of 'light_bloc.dart';

abstract class LightEvent extends Equatable {
  const LightEvent();

  @override
  List<Object> get props => [];
}

class LoadLights extends LightEvent {}

class LoadUngroupedLightsEvent extends LightEvent {}