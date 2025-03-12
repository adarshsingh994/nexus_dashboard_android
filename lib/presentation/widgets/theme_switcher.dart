import 'package:flutter/material.dart';

class ThemeSwitcher extends StatelessWidget {
  final Color currentColor;
  final ValueChanged<Color> onColorSelected;

  const ThemeSwitcher({
    super.key,
    required this.currentColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Define a list of predefined colors
    final List<Color> colors = [
      Colors.blue,
      Colors.indigo,
      Colors.purple,
      Colors.deepPurple,
      Colors.red,
      Colors.pink,
      Colors.orange,
      Colors.amber,
      Colors.green,
      Colors.teal,
      Colors.cyan,
      Colors.lightBlue,
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose a Theme Color',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Select a color to customize the app theme',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          
          // Current color preview
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Current Color:',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(width: 16),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: currentColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colorScheme.outline.withOpacity(0.5),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: currentColor.withOpacity(0.4),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Color grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1,
            ),
            itemCount: colors.length,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              final color = colors[index];
              final isSelected = color.value == currentColor.value;
              
              return GestureDetector(
                onTap: () => onColorSelected(color),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline.withOpacity(0.5),
                      width: isSelected ? 3 : 1,
                    ),
                    boxShadow: [
                      if (isSelected)
                        BoxShadow(
                          color: color.withOpacity(0.4),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                    ],
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 24,
                        )
                      : null,
                ),
              );
            },
          ),
          
          const SizedBox(height: 24),
          
          // Custom color picker button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              onPressed: () {
                // Show color picker dialog
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Pick a custom color'),
                    content: SingleChildScrollView(
                      child: ColorPicker(
                        pickerColor: currentColor,
                        onColorChanged: onColorSelected,
                        enableAlpha: false,
                        labelTypes: const [],
                        pickerAreaHeightPercent: 0.8,
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Done'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.colorize),
              label: const Text('Custom Color'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Simple color picker widget
class ColorPicker extends StatefulWidget {
  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;
  final bool enableAlpha;
  final List<ColorLabelType> labelTypes;
  final double pickerAreaHeightPercent;

  const ColorPicker({
    super.key,
    required this.pickerColor,
    required this.onColorChanged,
    this.enableAlpha = true,
    this.labelTypes = const [ColorLabelType.hsl, ColorLabelType.rgb],
    this.pickerAreaHeightPercent = 1.0,
  });

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

enum ColorLabelType { hsl, rgb }

class _ColorPickerState extends State<ColorPicker> {
  late HSVColor _currentHsvColor;

  @override
  void initState() {
    super.initState();
    _currentHsvColor = HSVColor.fromColor(widget.pickerColor);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Color preview
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: _colorFromHSV(),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: _colorFromHSV().withOpacity(0.3),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        
        // Hue slider
        _buildSlider(
          'Hue',
          _currentHsvColor.hue,
          360.0,
          (value) {
            setState(() {
              _currentHsvColor = _currentHsvColor.withHue(value);
              widget.onColorChanged(_colorFromHSV());
            });
          },
          _buildHueGradient(),
        ),
        
        // Saturation slider
        _buildSlider(
          'Saturation',
          _currentHsvColor.saturation,
          1.0,
          (value) {
            setState(() {
              _currentHsvColor = _currentHsvColor.withSaturation(value);
              widget.onColorChanged(_colorFromHSV());
            });
          },
          _buildSaturationGradient(),
        ),
        
        // Value slider
        _buildSlider(
          'Brightness',
          _currentHsvColor.value,
          1.0,
          (value) {
            setState(() {
              _currentHsvColor = _currentHsvColor.withValue(value);
              widget.onColorChanged(_colorFromHSV());
            });
          },
          _buildValueGradient(),
        ),
        
        // Alpha slider (optional)
        if (widget.enableAlpha)
          _buildSlider(
            'Alpha',
            _currentHsvColor.alpha,
            1.0,
            (value) {
              setState(() {
                _currentHsvColor = _currentHsvColor.withAlpha(value);
                widget.onColorChanged(_colorFromHSV());
              });
            },
            _buildAlphaGradient(),
          ),
      ],
    );
  }

  Widget _buildSlider(
    String label,
    double value,
    double max,
    ValueChanged<double> onChanged,
    Gradient gradient,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 8.0),
          child: Text(
            '$label: ${(value / max * 100).round()}%',
            style: const TextStyle(fontSize: 12),
          ),
        ),
        Container(
          height: 24,
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: SliderTheme(
            data: SliderThemeData(
              trackHeight: 24,
              trackShape: const RoundedRectSliderTrackShape(),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
              thumbColor: Colors.white,
              overlayColor: Colors.white.withOpacity(0.2),
            ),
            child: Slider(
              value: value,
              min: 0,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Gradient _buildHueGradient() {
    return const LinearGradient(
      colors: [
        Color.fromARGB(255, 255, 0, 0),
        Color.fromARGB(255, 255, 255, 0),
        Color.fromARGB(255, 0, 255, 0),
        Color.fromARGB(255, 0, 255, 255),
        Color.fromARGB(255, 0, 0, 255),
        Color.fromARGB(255, 255, 0, 255),
        Color.fromARGB(255, 255, 0, 0),
      ],
    );
  }

  Gradient _buildSaturationGradient() {
    return LinearGradient(
      colors: [
        HSVColor.fromAHSV(1.0, _currentHsvColor.hue, 0.0, _currentHsvColor.value).toColor(),
        HSVColor.fromAHSV(1.0, _currentHsvColor.hue, 1.0, _currentHsvColor.value).toColor(),
      ],
    );
  }

  Gradient _buildValueGradient() {
    return LinearGradient(
      colors: [
        HSVColor.fromAHSV(1.0, _currentHsvColor.hue, _currentHsvColor.saturation, 0.0).toColor(),
        HSVColor.fromAHSV(1.0, _currentHsvColor.hue, _currentHsvColor.saturation, 1.0).toColor(),
      ],
    );
  }

  Gradient _buildAlphaGradient() {
    return LinearGradient(
      colors: [
        HSVColor.fromAHSV(0.0, _currentHsvColor.hue, _currentHsvColor.saturation, _currentHsvColor.value).toColor(),
        HSVColor.fromAHSV(1.0, _currentHsvColor.hue, _currentHsvColor.saturation, _currentHsvColor.value).toColor(),
      ],
    );
  }

  Color _colorFromHSV() {
    return _currentHsvColor.toColor();
  }
}