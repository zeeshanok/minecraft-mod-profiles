import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SmallIconButton extends StatelessWidget {
  final Widget icon;
  final void Function() onPressed;
  final EdgeInsetsGeometry padding;
  SmallIconButton(
      {@required this.icon, @required this.onPressed, this.padding});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        child: Container(child: icon, padding: padding ?? EdgeInsets.zero),
        onTap: onPressed,
      ),
    );
  }
}
