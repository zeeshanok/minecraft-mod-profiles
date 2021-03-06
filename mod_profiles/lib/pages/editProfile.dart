import 'package:flutter/material.dart';
import 'package:mod_profiles/models/profile.dart';
import 'package:mod_profiles/models/profileModel.dart';
import 'package:mod_profiles/widgets/EscapePop.dart';
import 'package:mod_profiles/widgets/hintedIcon.dart';
import 'package:mod_profiles/widgets/profileEditor.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  final Profile profile;
  final int index;

  EditProfilePage({this.profile, this.index});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool editing = false;

  void handleEdit(BuildContext context, Profile profile) async {
    setState(() => editing = true);
    await Provider.of<ProfileModel>(context, listen: false)
        .editProfile(widget.index, profile);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    Profile p = Profile(
        widget.profile.name,
        widget.profile.mods
            .map((e) => Provider.of<ProfileModel>(context, listen: false)
                .getFullProfileModPath(e))
            .toList());
    return EscapePop(
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              title: Text("Edit Profile"),
              leading: HintedIconButton.escapePop(context)),
          body: ProfileEditor(
            mode: ProfileEditMode.Edit,
            profile: p,
            onSubmit: (profile) => handleEdit(context, profile),
            submitButtonIcon: Icon(Icons.done),
            showButtonSpinner: editing,
          )),
    );
  }
}
