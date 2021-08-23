import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EscapePop extends StatelessWidget {
  final Widget? child;
  final void Function(RawKeyEvent)? onKey;

  EscapePop({this.child, this.onKey});

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: onKey ?? (value) {
        if (value.isKeyPressed(LogicalKeyboardKey.escape)) {
          Navigator.of(context).pop();
        }
      },
      child: child!,
    );
  }
}
