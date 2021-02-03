import 'package:flutter/material.dart';
import 'package:mod_profiles/models/profile.dart';
import 'package:mod_profiles/models/profileModel.dart';
import 'package:mod_profiles/widgets/EscapePop.dart';
import 'package:mod_profiles/widgets/hintedIcon.dart';
import 'package:mod_profiles/widgets/profileEditor.dart';
import 'package:provider/provider.dart';

class AddProfilePage extends StatefulWidget {
  @override
  _AddProfilePageState createState() => _AddProfilePageState();
}

class _AddProfilePageState extends State<AddProfilePage> {
  void handleSubmit(Profile profile) {
    Provider.of<ProfileModel>(context, listen: false).addProfile(profile);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return EscapePop(
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              title: Text("Add Profile"),
              leading: HintedIconButton.escapePop(context)),
          body: ProfileEditor(
            mode: ProfileEditMode.Create,
            onSubmit: (profile) => handleSubmit(profile),
          )),
    );
  }
}
