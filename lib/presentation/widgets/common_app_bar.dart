import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_dashboard/presentation/bloc/theme/theme_bloc.dart';
import 'package:nexus_dashboard/presentation/widgets/theme_switcher.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final ValueChanged<Color>? onColorChanged;
  final List<Widget>? actions;

  const CommonAppBar({
    super.key,
    required this.title,
    this.onColorChanged,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeBloc = BlocProvider.of<ThemeBloc>(context);
    
    return AppBar(
      title: Text(title),
      centerTitle: true,
      scrolledUnderElevation: 0,
      actions: [
        // Add any additional actions passed to the widget
        if (actions != null) ...actions!,
        
        // Add the theme switcher
        IconButton(
          icon: const Icon(Icons.palette_outlined),
          tooltip: 'Change Theme Color',
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => ThemeSwitcher(
                currentColor: themeBloc.state.seedColor,
                onColorSelected: (color) {
                  if (onColorChanged != null) {
                    onColorChanged!(color);
                  } else {
                    themeBloc.add(ChangeSeedColor(color));
                  }
                  Navigator.pop(context);
                },
              ),
              backgroundColor: theme.colorScheme.surface,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}