import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'; // Import for ScrollDirection
import 'package:flutter/rendering.dart'; // Import for ScrollDirection
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_dashboard/domain/entities/group_entity.dart';
import 'package:nexus_dashboard/domain/entities/group_state_entity.dart';
import 'package:nexus_dashboard/presentation/bloc/home/home_bloc.dart';
import 'package:nexus_dashboard/presentation/bloc/theme/theme_bloc.dart';
import 'package:nexus_dashboard/presentation/widgets/common_app_bar.dart';
import 'package:nexus_dashboard/presentation/widgets/group_card.dart';
import 'package:nexus_dashboard/presentation/widgets/theme_switcher.dart';

class HomePage extends StatefulWidget {
  final String title;
  final Function(bool)? onScroll;

  const HomePage({
    super.key,
    required this.title,
    this.onScroll,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrollingDown = false;
  
  @override
  void initState() {
    super.initState();
    // Load groups when the page is initialized
    context.read<HomeBloc>().add(LoadGroups());
    
    // Add scroll listener
    _scrollController.addListener(_scrollListener);
  }
  
  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }
  
  void _scrollListener() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (!_isScrollingDown) {
        _isScrollingDown = true;
        widget.onScroll?.call(true);
      }
    }
    
    if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      if (_isScrollingDown) {
        _isScrollingDown = false;
        widget.onScroll?.call(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: true,
              snap: true,
              title: Text(widget.title),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.palette_outlined),
                  tooltip: 'Change Theme Color',
                  onPressed: () {
                    final themeBloc = context.read<ThemeBloc>();
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => ThemeSwitcher(
                        currentColor: themeBloc.state.seedColor,
                        onColorSelected: (color) {
                          context.read<ThemeBloc>().add(ChangeSeedColor(color));
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
            ),
          ];
        },
        body: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is HomeOperationError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is HomeLoading) {
              return _buildLoadingView();
            } else if (state is HomeError) {
              return _buildErrorView(state.message);
            } else if (state is HomeLoaded) {
              return state.groups.isEmpty
                  ? _buildEmptyView()
                  : _buildGroupsGrid(state.groups);
            }
            return _buildLoadingView();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Loading groups...',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(String errorMessage) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: BorderSide(
              color: theme.colorScheme.errorContainer,
              width: 1,
            ),
          ),
          color: theme.colorScheme.errorContainer.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.error_outline_rounded,
                    color: theme.colorScheme.onErrorContainer,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Error Loading Groups',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.error,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () => context.read<HomeBloc>().add(LoadGroups()),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Retry'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    final theme = Theme.of(context);

    return Center(
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
                color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.dashboard_rounded,
                    size: 80,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Title with decorative underline
            Column(
              children: [
                Text(
                  'No Groups Found',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 80,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
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
                'Create groups in the Groups tab to control them from here',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            // Action button
            FilledButton.icon(
              icon: const Icon(Icons.group_add_rounded),
              label: const Text('Go to Groups'),
              onPressed: () {
                // Navigate to the Groups tab (index 1)
                DefaultTabController.of(context)?.animateTo(1);
              },
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                minimumSize: const Size(200, 56),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupsGrid(List<GroupEntity> groups) {
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: () async {
        context.read<HomeBloc>().add(LoadGroups());
      },
      color: theme.colorScheme.primary,
      backgroundColor: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Determine the number of columns based on screen width
            int crossAxisCount;
            double aspectRatio;

            if (constraints.maxWidth < 300) {
              // Very small screens: 1 column
              crossAxisCount = 1;
              aspectRatio = 0.9;
            } else if (constraints.maxWidth < 450) {
              // Small screens: 2 columns
              crossAxisCount = 2;
              aspectRatio = 0.85;
            } else if (constraints.maxWidth < 600) {
              // Medium screens: 3 columns
              crossAxisCount = 3;
              aspectRatio = 0.8;
            } else if (constraints.maxWidth < 900) {
              // Large screens: 4 columns
              crossAxisCount = 4;
              aspectRatio = 0.75;
            } else {
              // Extra large screens: 5 columns
              crossAxisCount = 5;
              aspectRatio = 0.7;
            }

            return GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(), // Allow scrolling within NestedScrollView
              padding: const EdgeInsets.only(top: 8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: aspectRatio,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];
                return GroupCard(
                  group: group,
                  onTogglePower: () {
                    context.read<HomeBloc>().add(ToggleGroupPower(group: group));
                  },
                  onStateChanged: (newState) {
                    context.read<HomeBloc>().add(
                          UpdateGroupState(
                            groupId: group.id,
                            newState: newState,
                          ),
                        );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}