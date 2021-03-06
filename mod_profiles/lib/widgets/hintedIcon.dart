import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mod_profiles/utils/consts.dart';

class HintedIconButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final TextStyle labelStyle;
  final void Function() onPressed;

  HintedIconButton({this.icon, this.label, this.labelStyle, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 8),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            icon,
            Text(
              label,
              style: labelStyle ?? keyboardHintTextStyle(),
            )
          ]),
        ),
      ),
    );
  }

  factory HintedIconButton.escapePop(BuildContext context) {
    return HintedIconButton(
      icon: Icon(Icons.close),
      label: "ESC",
      onPressed: () => Navigator.of(context).pop(),
    );
  }
}
