import 'package:flutter/material.dart';
import 'package:mod_profiles/widgets/EscapePop.dart';
import 'package:mod_profiles/widgets/hintedIcon.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EscapePop(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          title: Text("Settings"),
          leading: HintedIconButton.escapePop(context),
        ),
      ),
    );
  }
}
