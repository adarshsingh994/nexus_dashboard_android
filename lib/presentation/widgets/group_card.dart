import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:nexus_dashboard/domain/entities/group_entity.dart';
import 'package:nexus_dashboard/domain/entities/group_state_entity.dart';

class GroupCard extends StatefulWidget {
  final GroupEntity group;
  final VoidCallback onTogglePower;
  final Function(GroupStateEntity) onStateChanged;

  const GroupCard({
    super.key,
    required this.group,
    required this.onTogglePower,
    required this.onStateChanged,
  });

  @override
  State<GroupCard> createState() => _GroupCardState();
}

class _GroupCardState extends State<GroupCard> with SingleTickerProviderStateMixin {
  late GroupStateEntity _groupState;
  bool _isLoading = false;
  Color _currentColor = Colors.red;
  int _warmWhiteIntensity = 128;
  int _coldWhiteIntensity = 128;
  
  // Animation controller for power button
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    _initializeGroupState();
    
    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }
  
  // Initialize state from the group's state
  void _initializeGroupState() {
    if (widget.group.state != null) {
      _groupState = widget.group.state!;
      
      // Initialize color from RGB if available
      if (_groupState.rgb != null && _groupState.rgb!.length >= 3) {
        _currentColor = Color.fromRGBO(
          _groupState.rgb![0],
          _groupState.rgb![1],
          _groupState.rgb![2],
          1.0
        );
      }
      
      // Initialize white intensities if available
      _warmWhiteIntensity = _groupState.warmWhiteIntensity ?? 128;
      _coldWhiteIntensity = _groupState.coldWhiteIntensity ?? 128;
    } else {
      // Default state if none is provided
      _groupState = const GroupStateEntity(isOn: false);
    }
  }
  
  @override
  void didUpdateWidget(GroupCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // If the group state has changed, update our local state
    if (widget.group.state != oldWidget.group.state) {
      _initializeGroupState();
      // Reset loading state when we receive updated props
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  Future<void> _togglePower() async {
    // Play animation
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    
    // Show loading state
    setState(() {
      _isLoading = true;
    });
    
    widget.onTogglePower();
  }
  
  void _showColorPicker() {
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Pick a color',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          icon: Icon(
            Icons.palette_outlined,
            color: theme.colorScheme.primary,
            size: 28,
          ),
          content: SingleChildScrollView(
            child: _buildHueOnlyColorPicker(
              _currentColor,
              (Color color) {
                setState(() {
                  _currentColor = color;
                });
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FilledButton(
              child: const Text('Apply'),
              onPressed: () {
                _setColor(_currentColor);
                Navigator.of(context).pop();
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          backgroundColor: theme.colorScheme.surface,
          surfaceTintColor: Colors.transparent,
          elevation: 6,
        );
      },
    );
  }
  
  void _showWhiteControls() {
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                'White Light Controls',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              icon: Icon(
                Icons.wb_sunny_outlined,
                color: theme.colorScheme.primary,
                size: 28,
              ),
              content: Container(
                width: double.maxFinite,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.wb_sunny,
                          color: Colors.amber,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Warm White',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '0',
                                style: theme.textTheme.bodySmall,
                              ),
                              Text(
                                '${_warmWhiteIntensity.toInt()}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              Text(
                                '255',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                          Slider(
                            value: _warmWhiteIntensity.toDouble(),
                            min: 0,
                            max: 255,
                            divisions: 255,
                            label: _warmWhiteIntensity.toString(),
                            activeColor: theme.colorScheme.primary,
                            inactiveColor: theme.colorScheme.primary.withOpacity(0.3),
                            onChanged: (double value) {
                              setState(() {
                                _warmWhiteIntensity = value.toInt();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Icon(
                          Icons.wb_sunny,
                          color: Colors.lightBlueAccent,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Cold White',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '0',
                                style: theme.textTheme.bodySmall,
                              ),
                              Text(
                                '${_coldWhiteIntensity.toInt()}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.secondary,
                                ),
                              ),
                              Text(
                                '255',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                          Slider(
                            value: _coldWhiteIntensity.toDouble(),
                            min: 0,
                            max: 255,
                            divisions: 255,
                            label: _coldWhiteIntensity.toString(),
                            activeColor: theme.colorScheme.secondary,
                            inactiveColor: theme.colorScheme.secondary.withOpacity(0.3),
                            onChanged: (double value) {
                              setState(() {
                                _coldWhiteIntensity = value.toInt();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FilledButton.icon(
                  icon: const Icon(Icons.wb_sunny_outlined),
                  label: const Text('Apply Warm'),
                  onPressed: () {
                    _setWarmWhite(_warmWhiteIntensity);
                    Navigator.of(context).pop();
                  },
                ),
                FilledButton.icon(
                  icon: const Icon(Icons.wb_sunny_outlined),
                  label: const Text('Apply Cold'),
                  onPressed: () {
                    _setColdWhite(_coldWhiteIntensity);
                    Navigator.of(context).pop();
                  },
                ),
              ],
              actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              backgroundColor: theme.colorScheme.surface,
              surfaceTintColor: Colors.transparent,
              elevation: 6,
            );
          }
        );
      },
    );
  }

  // Custom color picker that only shows the hue ring with maximum brightness
  Widget _buildHueOnlyColorPicker(Color initialColor, ValueChanged<Color> onColorChanged) {
    final theme = Theme.of(context);
    
    // Convert initial color to HSV and ensure maximum brightness
    HSVColor hsvColor = HSVColor.fromColor(initialColor);
    // Always use maximum saturation and value (brightness)
    Color safeInitialColor = HSVColor.fromAHSV(
      hsvColor.alpha,
      hsvColor.hue,
      1.0, // Maximum saturation
      1.0, // Maximum brightness (100%)
    ).toColor();
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Display the current color
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: safeInitialColor,
            shape: BoxShape.circle,
            border: Border.all(color: theme.colorScheme.outline.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        
        // Use HueRingPicker which only shows the hue selection
        HueRingPicker(
          pickerColor: safeInitialColor,
          onColorChanged: (Color color) {
            // Extract just the hue from the selected color
            final hue = HSVColor.fromColor(color).hue;
            
            // Create a new color with this hue but maximum saturation and brightness
            final newColor = HSVColor.fromAHSV(
              1.0, // Alpha
              hue,
              1.0, // Maximum saturation
              1.0, // Maximum brightness (100%)
            ).toColor();
            
            // Call the original callback with the adjusted color
            onColorChanged(newColor);
          },
          displayThumbColor: true,
          portraitOnly: true,
        ),
        
        const SizedBox(height: 16),
        Text(
          'Select a hue for your LED lights (always at maximum brightness)',
          style: theme.textTheme.bodySmall?.copyWith(
            fontStyle: FontStyle.italic,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _setColor(Color color) {
    setState(() {
      _isLoading = true;
    });
    
    final rgb = [color.red, color.green, color.blue];
    
    // Store the color for UI updates
    final selectedColor = color;
    
    // Update local state immediately
    setState(() {
      _currentColor = selectedColor;
      _groupState = _groupState.copyWith(
        isOn: true,
        rgb: rgb,
      );
      _isLoading = false;
    });
    
    // Notify parent - this will trigger the API call through HomeBloc
    widget.onStateChanged(_groupState);
  }

  void _setWarmWhite(int intensity) {
    setState(() {
      _isLoading = true;
    });
    
    // Store the intensity value for UI updates
    final selectedIntensity = intensity;
    
    // Update local state immediately
    setState(() {
      _warmWhiteIntensity = selectedIntensity;
      _groupState = _groupState.copyWith(
        isOn: true,
        warmWhiteIntensity: selectedIntensity,
      );
      _isLoading = false;
    });
    
    // Notify parent - this will trigger the API call through HomeBloc
    widget.onStateChanged(_groupState);
  }

  void _setColdWhite(int intensity) {
    setState(() {
      _isLoading = true;
    });
    
    // Store the intensity value for UI updates
    final selectedIntensity = intensity;
    
    // Update local state immediately
    setState(() {
      _coldWhiteIntensity = selectedIntensity;
      _groupState = _groupState.copyWith(
        isOn: true,
        coldWhiteIntensity: selectedIntensity,
      );
      _isLoading = false;
    });
    
    // Notify parent - this will trigger the API call through HomeBloc
    widget.onStateChanged(_groupState);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Define colors based on state
    final cardColor = _groupState.isOn
        ? theme.colorScheme.primary
        : theme.colorScheme.surfaceVariant;
    
    final contentColor = _groupState.isOn
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.onSurfaceVariant;
    
    return Card(
      elevation: 2,
      shadowColor: _groupState.isOn
          ? theme.colorScheme.primary.withOpacity(0.4)
          : theme.shadowColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      surfaceTintColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _groupState.isOn
                ? theme.colorScheme.primary
                : theme.colorScheme.surfaceVariant,
              _groupState.isOn
                ? theme.colorScheme.primary.withOpacity(0.8)
                : theme.colorScheme.surface,
            ],
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _isLoading ? null : _togglePower,
            borderRadius: BorderRadius.circular(24),
            splashColor: theme.colorScheme.primary.withOpacity(0.1),
            highlightColor: theme.colorScheme.primary.withOpacity(0.05),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Power button icon with animation
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _groupState.isOn
                          ? Colors.white
                          : theme.colorScheme.surface,
                        boxShadow: [
                          BoxShadow(
                            color: _groupState.isOn
                              ? cardColor.withOpacity(0.3)
                              : theme.shadowColor.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: _isLoading
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _groupState.isOn
                                ? theme.colorScheme.primary
                                : theme.colorScheme.secondary
                            ),
                          )
                        : Icon(
                            Icons.power_settings_new_rounded,
                            size: 24,
                            color: _groupState.isOn
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                          ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Group name
                  Text(
                    widget.group.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: contentColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  // Group description
                  Text(
                    widget.group.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: contentColor.withOpacity(0.8),
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  // Control buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Color picker button
                      Container(
                        decoration: BoxDecoration(
                          color: _groupState.isOn
                            ? Colors.white.withOpacity(0.2)
                            : theme.colorScheme.surface.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: _isLoading ? null : _showColorPicker,
                          icon: Icon(
                            Icons.palette_outlined,
                            color: contentColor,
                          ),
                          tooltip: 'Change color',
                          iconSize: 18,
                          style: IconButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // White control button
                      Container(
                        decoration: BoxDecoration(
                          color: _groupState.isOn
                            ? Colors.white.withOpacity(0.2)
                            : theme.colorScheme.surface.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: _isLoading ? null : _showWhiteControls,
                          icon: Icon(
                            Icons.wb_sunny_outlined,
                            color: contentColor,
                          ),
                          tooltip: 'Adjust white light',
                          iconSize: 18,
                          style: IconButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}