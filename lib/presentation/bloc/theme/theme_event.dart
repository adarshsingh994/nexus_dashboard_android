part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class ChangeSeedColor extends ThemeEvent {
  final Color newColor;

  const ChangeSeedColor(this.newColor);

  @override
  List<Object> get props => [newColor];
}