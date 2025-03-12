part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  final Color seedColor;

  const ThemeState({
    required this.seedColor,
  });

  ThemeState copyWith({
    Color? seedColor,
  }) {
    return ThemeState(
      seedColor: seedColor ?? this.seedColor,
    );
  }

  @override
  List<Object> get props => [seedColor];
}