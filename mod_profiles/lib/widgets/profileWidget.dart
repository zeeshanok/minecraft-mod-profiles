import 'package:flutter/material.dart';
import 'package:mod_profiles/models/profile.dart';
import 'package:mod_profiles/pages/editProfile.dart';
import 'package:mod_profiles/utils/consts.dart';
import 'package:mod_profiles/widgets/confirmDialog.dart';
import 'package:mod_profiles/widgets/smallIconButton.dart';
import 'package:path/path.dart';

class ProfileWidget extends StatefulWidget {
  final Profile profile;
  final int index;
  final Future Function(BuildContext context) onActivate;
  final void Function(BuildContext context) onDelete;
  final bool showActivateDialog;
  final bool showDeleteDialog;
  final bool activateButtonIsDisabled;
  final bool isSelected;

  ProfileWidget(
      {this.profile,
      this.index,
      this.activateButtonIsDisabled,
      this.onActivate,
      this.onDelete,
      this.showActivateDialog,
      this.showDeleteDialog,
      this.isSelected});

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  void handleActivate(BuildContext context) async {
    var activate = () async {
      await widget.onActivate(context);
    };
    if (widget.showActivateDialog) {
      showDialog(
          context: context,
          builder: (context) => ConfirmDialog(
                onSubmit: (response) async {
                  if (response) await activate();
                },
                title: Text("Are you sure you want to activate this profile?"),
                content: Text(
                    "This will clear your mods folder and copy your profile's mods into your mods folder."),
              ));
    } else {
      await activate();
    }
  }

  void handleDelete(BuildContext context) {
    if (widget.showDeleteDialog ?? true) {
      showDialog(
          context: context,
          builder: (context) => ConfirmDialog(
                onSubmit: (response) {
                  if (response) widget.onDelete(context);
                },
                title: Text("Are you sure you want to delete this profile?"),
              ));
    } else {
      widget.onDelete(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            border:
                Border.all(color: Theme.of(context).accentColor, width: 1.5),
            borderRadius: BorderRadius.circular(7)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.profile.name,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
                // ShortenedList(
                //   builder: (context, i) {
                //     var mods = profile.modsSorted;
                //     return Text(
                //       getFileName(mods[i]
                //           .substring(0, mods[i].length - 4)
                //           .replaceAll(RegExp(r"[-_]+"), " ")),
                //       style: TextStyle(color: Colors.grey[300]),
                //     );
                //   },
                //   itemCount: profile.mods.length,
                //   maxItems: 0,
                //   shortenedText: 'Show mods',
                //   expandedText: 'Hide',
                // )
                TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) => AlertDialog(
                          content: SizedBox(
                              height: 200,
                              width: 400,
                              child: Scrollbar(
                                  thickness: 5,
                                  isAlwaysShown: true,
                                  child: ListView.builder(
                                      itemCount: widget.profile.mods.length,
                                      itemBuilder: (context, i) =>
                                          SelectableText(getFileName(widget
                                              .profile.mods[i]
                                              .substring(
                                                  0,
                                                  widget.profile.mods[i]
                                                          .length -
                                                      4)
                                              .replaceAll(
                                                  RegExp(r"[-_]+"), " ")))))),
                          title: Text("Mods"),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text("Ok"))
                          ],
                        ),
                      );
                    },
                    child: Text("Show mods"))
              ],
            ),
            SizedBox(
              width: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: widget.activateButtonIsDisabled
                        ? null
                        : () => handleActivate(context),
                    child: Text(widget.isSelected ? "Selected" : "Select"),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (states) =>
                              widget.isSelected ? Colors.transparent : null),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SmallIconButton(
                        icon: Icon(
                          Icons.edit,
                          size: 20,
                        ),
                        onPressed: () async {
                          Navigator.of(context)
                              .push(createRoute(EditProfilePage(
                            profile: widget.profile,
                            index: widget.index,
                          )));
                        },
                      ),
                      SmallIconButton(
                        icon: Icon(
                          Icons.close,
                          size: 20,
                        ),
                        onPressed: () async {
                          handleDelete(context);
                        },
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ));
  }
}
