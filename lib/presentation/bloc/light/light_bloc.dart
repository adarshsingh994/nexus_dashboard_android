import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus_dashboard/domain/entities/light_entity.dart';
import 'package:nexus_dashboard/domain/usecases/light/get_lights.dart';

part 'light_event.dart';
part 'light_state.dart';

class LightBloc extends Bloc<LightEvent, LightState> {
  final GetLights getLights;
  final GetUngroupedLights getUngroupedLights;

  LightBloc({
    required this.getLights,
    required this.getUngroupedLights,
  }) : super(LightInitial()) {
    on<LoadLights>(_onLoadLights);
    on<LoadUngroupedLightsEvent>(_onLoadUngroupedLights);
  }

  Future<void> _onLoadLights(LoadLights event, Emitter<LightState> emit) async {
    emit(LightLoading());
    
    final result = await getLights();
    
    result.fold(
      (failure) => emit(LightError(message: failure.message)),
      (lights) => emit(LightLoaded(lights: lights)),
    );
  }

  Future<void> _onLoadUngroupedLights(LoadUngroupedLightsEvent event, Emitter<LightState> emit) async {
    emit(LightLoading());
    
    final result = await getUngroupedLights();
    
    result.fold(
      (failure) => emit(LightError(message: failure.message)),
      (lights) => emit(UngroupedLightsLoaded(lights: lights)),
    );
  }
}