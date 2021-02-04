import 'package:flutter/material.dart';
import 'package:mod_profiles/models/profileModel.dart';
import 'package:mod_profiles/utils/consts.dart';
import 'package:mod_profiles/widgets/colorSquare.dart';
import 'package:provider/provider.dart';

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

    List<Widget> colors = widget.colors
        .map((color) => ColorSquare(
              size: 40,
              color: color,
              onActive: () {
                widget.onPressed?.call(color);
                setState(
                  () => active = color,
                );
              },
              active: active.value == color.value,
              hoverBorderColor: Theme.of(context).scaffoldBackgroundColor
            ))
        .toList();
    return Column(
        children: splitList(colors, widget.crossAxisCount ?? 4)
            .map((val) => Row(
                  children: val,
                ))
            .toList());
  }
}
