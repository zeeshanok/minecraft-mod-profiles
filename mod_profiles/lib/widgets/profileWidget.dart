import 'package:flutter/material.dart';
import 'package:mod_profiles/models/profile.dart';
import 'package:mod_profiles/pages/editProfile.dart';
import 'package:mod_profiles/utils/consts.dart';
import 'package:mod_profiles/widgets/confirmDialog.dart';
import 'package:mod_profiles/widgets/expandableModList.dart';
import 'package:mod_profiles/widgets/smallIconButton.dart';

class ProfileWidget extends StatefulWidget {
  final Profile profile;
  final int index;
  final Future Function() onSelect;
  final void Function() onDeselect;
  final void Function() onDelete;
  final bool? showDeleteDialog;
  final bool activateButtonIsDisabled;
  final bool isSelected;

  ProfileWidget({
    required this.profile,
    required this.index,
    required this.activateButtonIsDisabled,
    required this.onSelect,
    required this.onDeselect,
    required this.onDelete,
    required this.isSelected,
    this.showDeleteDialog,
  });

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  double _blur = 0;
  int _alpha = 190;

  @override
  void didUpdateWidget(covariant ProfileWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      if (widget.isSelected) {
        _blur = 10;
        _alpha = 255;
      } else {
        _blur = 0;
        _alpha = 190;
      }
    });
  }

  void handleDelete(BuildContext context) async {
    if (widget.showDeleteDialog ?? true) {
      await showDialog(
          context: context,
          builder: (context) => ConfirmDialog(
                onSubmit: (response) {
                  if (response) widget.onDelete();
                },
                title: Text("Are you sure you want to delete this profile?"),
              ));
    } else {
      widget.onDelete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.fastOutSlowIn,
        padding: EdgeInsets.fromLTRB(12, 10, 8, 8),
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            border: Border.all(
                color: Theme.of(context).accentColor.withAlpha(_alpha),
                width: 1.5),
            borderRadius: BorderRadius.circular(7),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                        blurRadius: _blur, color: Theme.of(context).accentColor)
                  ]
                : null),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.profile.name!,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                    ),
                    ExpandableWidget(
                        showText: 'Mods',
                        animationCurve: Curves.fastOutSlowIn,
                        animationDuration: Duration(milliseconds: 200),
                        child: SelectableText(widget.profile.mods!
                            .map((e) => "• $e")
                            .join("\n")
                            .replaceAll(RegExp(r"[-_]+"), " ")
                            .replaceAll(".jar", "")))
                  ]),
              SizedBox(
                width: 180,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: (widget.activateButtonIsDisabled
                          ? null
                          : (widget.isSelected
                              ? widget.onDeselect
                              : () async => await widget.onSelect())),
                      child: Text(widget.isSelected ? "Selected" : "Select"),
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
            ]));
  }
}
