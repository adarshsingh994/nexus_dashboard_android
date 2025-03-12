import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus_dashboard/theme/app_theme.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(seedColor: AppTheme.defaultSeedColor)) {
    on<ChangeSeedColor>(_onChangeSeedColor);
  }

  void _onChangeSeedColor(ChangeSeedColor event, Emitter<ThemeState> emit) {
    emit(state.copyWith(seedColor: event.newColor));
  }
}