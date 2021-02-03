import 'package:flutter/material.dart';
import 'package:mod_profiles/widgets/colorSquare.dart';

class ColorPicker extends StatefulWidget {
  final List<Color> colors;
  final Color initialActive;
  final int crossAxisCount;
  final double size;
  final void Function(Color color) onPressed;

  ColorPicker({
    @required this.colors,
    @required this.size,
    this.initialActive,
    this.onPressed,
    this.crossAxisCount,
  });

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  Color active;

  @override
  void initState() {
    active = widget.initialActive;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: widget.crossAxisCount ?? 2,
        children: widget.colors.map(
          (color) {
            return ColorSquare(
              color: color,
              onActive: () {
                widget.onPressed?.call(color);
                setState(
                  () => active = color,
                );
              },
              active: active.value == color.value,
            );
          },
        ).toList());
  }
}
