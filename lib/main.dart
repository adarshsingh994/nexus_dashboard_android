import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_dashboard/injection_container.dart' as di;
import 'package:nexus_dashboard/presentation/bloc/group/group_bloc.dart';
import 'package:nexus_dashboard/presentation/bloc/group_details/group_details_bloc.dart';
import 'package:nexus_dashboard/presentation/bloc/group_management/group_management_bloc.dart';
import 'package:nexus_dashboard/presentation/bloc/home/home_bloc.dart';
import 'package:nexus_dashboard/presentation/bloc/light/light_bloc.dart';
import 'package:nexus_dashboard/presentation/bloc/theme/theme_bloc.dart';
import 'package:nexus_dashboard/presentation/pages/group_management_page.dart';
import 'package:nexus_dashboard/presentation/pages/home_page.dart';
import 'package:nexus_dashboard/presentation/widgets/common_app_bar.dart';
import 'package:nexus_dashboard/theme/app_theme.dart';

void main() async {
  // Initialize dependency injection
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          create: (context) => di.sl<ThemeBloc>(),
        ),
        BlocProvider<HomeBloc>(
          create: (context) => di.sl<HomeBloc>(),
        ),
        BlocProvider<GroupBloc>(
          create: (context) => di.sl<GroupBloc>(),
        ),
        BlocProvider<GroupManagementBloc>(
          create: (context) => di.sl<GroupManagementBloc>(),
        ),
        BlocProvider<GroupDetailsBloc>(
          create: (context) => di.sl<GroupDetailsBloc>(),
        ),
        BlocProvider<LightBloc>(
          create: (context) => di.sl<LightBloc>(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Nexus Dashboard',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.createTheme(seedColor: state.seedColor),
            darkTheme: AppTheme.createDarkTheme(seedColor: state.seedColor),
            themeMode: ThemeMode.system, // Respect system theme setting
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool _hideBottomNav = false;
  
  void _handleScroll(bool isScrollingDown) {
    setState(() {
      _hideBottomNav = isScrollingDown;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          // Home Tab
          HomePage(
            title: 'Nexus Dashboard',
            onScroll: _handleScroll,
          ),
          
          // Groups Tab
          const GroupManagementPage(),
          
          // Lights Tab (Coming Soon)
          _buildComingSoonPage('Lights'),
        ],
      ),
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: _hideBottomNav ? 0 : 80,
        child: AnimatedOpacity(
          opacity: _hideBottomNav ? 0 : 1,
          duration: const Duration(milliseconds: 200),
          child: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
                _hideBottomNav = false; // Show bottom nav when switching tabs
              });
            },
            backgroundColor: theme.colorScheme.surface,
            elevation: 3,
            height: 80,
            shadowColor: theme.shadowColor,
            indicatorColor: theme.colorScheme.primaryContainer,
            surfaceTintColor: Colors.transparent,
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard_rounded),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.group_outlined),
                selectedIcon: Icon(Icons.group_rounded),
                label: 'Groups',
              ),
              NavigationDestination(
                icon: Icon(Icons.lightbulb_outline_rounded),
                selectedIcon: Icon(Icons.lightbulb_rounded),
                label: 'Lights',
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildComingSoonPage(String feature) {
    final theme = Theme.of(context);
    final themeBloc = BlocProvider.of<ThemeBloc>(context);
    
    return Scaffold(
      appBar: CommonAppBar(
        title: feature,
        onColorChanged: (color) {
          themeBloc.add(ChangeSeedColor(color));
        },
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Decorative illustration container
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.secondary.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.hourglass_top_rounded,
                      size: 80,
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Title with decorative underline
              Column(
                children: [
                  Text(
                    '$feature Coming Soon',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 80,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Description text
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.outlineVariant,
                    width: 1,
                  ),
                ),
                child: Text(
                  'We\'re working hard to bring you this feature. Stay tuned for updates!',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              // Action button
              FilledButton.tonal(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('We\'ll notify you when this feature is available!'),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  );
                },
                child: const Text('Notify Me When Available'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  minimumSize: const Size(240, 56),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
