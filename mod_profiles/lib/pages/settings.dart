import 'dart:io';

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

  void openPath(ProfileModel model, String path) async {
    await Process.run("explorer.exe", [path]);
  }

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
                                .setThemeColor(color),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Row(
                            children: [
                              Text("Dark Mode",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Switch(
                                value: model.settings.isDarkMode,
                                onChanged: (value) => model.setDarkMode(value),
                              ),
                              Text(
                                model.settings.isDarkMode ? "ON" : "OFF",
                                style:
                                    TextStyle(letterSpacing: 1.4, fontSize: 10),
                              )
                            ],
                          ),
                        ],
                      )),
                  SettingsSection(
                      heading: "Folders and paths",
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            OutlinedButton(
                                onPressed: () => openPath(
                                    model, model.settings.profilesDir.path),
                                child: Text("Open")),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Profile config folder"),
                          ]),
                          SizedBox(
                            height: 5,
                          ),
                          Row(children: [
                            OutlinedButton(
                                onPressed: () => openPath(
                                    model, model.settings.minecraftModDir.path),
                                child: Text("Open")),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Minecraft mods folder"),
                          ])
                        ],
                      )),
                  SettingsSection(
                      heading: "Confirmation Dialogs",
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Ask before: "),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Switch(
                                        value: model.settings
                                            .confirmationSettings.onActivate,
                                        onChanged: (val) => model
                                            .settings
                                            .confirmationSettings
                                            .onActivate = val),
                                    Text("Activating a profile")
                                  ],
                                ),
                                Row(
                                  children: [
                                    Switch(
                                        value: model.settings
                                            .confirmationSettings.onDelete,
                                        onChanged: (val) => model
                                            .settings
                                            .confirmationSettings
                                            .onDelete = val),
                                    Text("Deleting a profile")
                                  ],
                                ),
                                Row(
                                  children: [
                                    Switch(
                                        value: model.settings
                                            .confirmationSettings.onClear,
                                        onChanged: (val) => model
                                            .settings
                                            .confirmationSettings
                                            .onClear = val),
                                    Text("Clearing all profiles")
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
