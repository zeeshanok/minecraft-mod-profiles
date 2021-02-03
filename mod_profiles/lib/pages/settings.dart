import 'package:flutter/material.dart';
import 'package:mod_profiles/models/profileModel.dart';
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
            child: Column(
              children: [
                SettingsSection(
                    heading: "Customization",
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text("Theme"),
                        Row(
                          children: [
                            Text("Light Mode"),
                            Consumer<ProfileModel>(builder: (context, model, child) => Switch.adaptive(
                              value: model.isDarkMode,
                              onChanged: (value) => model.setDarkMode(value),
                            )),
                            Text("Dark Mode")
                          ],
                        ),
                        SizedBox(width: 5,),
                        Container(
                          height: 200,
                          width: 200,
                          child: ColorPicker(
                            colors: [
                              Colors.cyan,
                              Colors.red,
                              Colors.green,
                              Colors.blue,
                              Colors.teal,
                              Colors.purple,
                              Colors.pink,
                              Colors.orange
                            ],
                            size: 15,
                            crossAxisCount: 4,
                            initialActive: Theme.of(context).accentColor,
                            onPressed: (color) =>
                                Provider.of<ProfileModel>(context, listen: false).setColor(color),
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Settings {}
