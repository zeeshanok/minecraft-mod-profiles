import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ColorSquare extends StatefulWidget {
  final Color color;
  final double? size;
  final Color? hoverBorderColor;
  final void Function() onActive;
  final bool active;
  ColorSquare({
    required this.color,
    required this.onActive,
    required this.active,
    this.size,
    this.hoverBorderColor,
  });

  @override
  _ColorSquareState createState() => _ColorSquareState();
}

class _ColorSquareState extends State<ColorSquare> {
  bool hover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onActive,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: widget.size ?? 20,
              height: widget.size ?? 20,
              decoration: BoxDecoration(
                  color: widget.color,
                  border: Border.all(
                      color: hover
                          ? (widget.hoverBorderColor ?? Colors.white)
                          : widget.color)),
              margin: EdgeInsets.all(3),
            ),
            if (widget.active) Icon(Icons.done)
          ],
        ),
      ),
    );
  }
}
