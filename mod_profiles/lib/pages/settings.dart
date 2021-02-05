import 'package:flutter/material.dart';
import 'package:mod_profiles/models/profileModel.dart';
import 'package:mod_profiles/utils/consts.dart';
import 'package:mod_profiles/widgets/EscapePop.dart';
import 'package:mod_profiles/widgets/colorPicker.dart';
import 'package:mod_profiles/widgets/hintedIcon.dart';
import 'package:mod_profiles/widgets/settingsSection.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final testKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return EscapePop(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          title: Text("Settings"),
          leading: HintedIconButton.escapePop(context),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Consumer<ProfileModel>(
              builder: (context, model, child) => Column(
                children: [
                  SettingsSection(
                      heading: "Theme",
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ColorPicker(
                            colors: allowedThemeColors,
                            size: 15,
                            crossAxisCount: 4,
                            initialActive: Theme.of(context).accentColor,
                            onPressed: (color) => Provider.of<ProfileModel>(
                                    context,
                                    listen: false)
                                .setColor(color),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Row(
                            children: [
                              Text("Dark Mode", style: TextStyle(fontWeight: FontWeight.bold)),
                              Switch(
                                value: model.isDarkMode,
                                onChanged: (value) => model.setDarkMode(value),
                              ),
                              Text(model.isDarkMode ? "ON" : "OFF", style: TextStyle(letterSpacing: 1.4, fontSize: 10),)
                            ],
                          ),
                        ],
                      )),
                  SettingsSection(heading: "Folders and paths", child: Column())
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Settings {}
