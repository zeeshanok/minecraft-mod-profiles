import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mod_profiles/models/profileModel.dart';
import 'package:mod_profiles/widgets/confirmDialog.dart';
import 'package:mod_profiles/widgets/hintedIcon.dart';
import 'package:mod_profiles/widgets/profileWidget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();

  HomePage();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int selectedIndex = -1;

  bool _isBusy = false;

  List<String> listDir(Directory dir) {
    List<String> list = [];
    for (var item in dir.listSync()) {
      list.add(item.path.replaceAll("/", "\\").split("\\").last);
    }
    return list;
  }

  void navigateToAdd() => Navigator.of(context).pushNamed('addProfile');

  void handleClear(BuildContext context) async {
    if (Provider.of<ProfileModel>(context, listen: false)
        .settings!
        .confirmationSettings!
        .onClear!) {
      showDialog(
        context: context,
        builder: (context) => ConfirmDialog(
            title: Text("Are you sure you want to delete all your profiles?"),
            onSubmit: (response) async {
              if (response)
                await Provider.of<ProfileModel>(context, listen: false)
                    .clearProfiles();
            }),
      );
    } else {
      await Provider.of<ProfileModel>(context, listen: false).clearProfiles();
    }
  }

  Future handleActivate(
      {BuildContext? context,
      required ProfileModel model,
      required int index}) async {
    setState(() => _isBusy = true);
    await model.activate(index);
    setState(() {
      selectedIndex = -1;
      _isBusy = false;
    });
  }

  void handleDelete(
      {required BuildContext context,
      ProfileModel? model,
      required int index}) {
    Provider.of<ProfileModel>(context, listen: false).removeProfile(index);
    if (index == selectedIndex) setState(() => selectedIndex = -1);
  }

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).appBarTheme.backgroundColor;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: color,
          title: Padding(
              padding: EdgeInsets.only(left: 5), child: Text("Mod Profiles")),
          actions: [
            Provider.of<ProfileModel>(context).profiles.length > 0
                ? HintedIconButton(
                    icon: Icon(
                      Icons.delete_sweep_outlined,
                      size: 23,
                    ),
                    onPressed: () => handleClear(context),
                    label: "Clear",
                    labelStyle: TextStyle(fontSize: 13),
                  )
                : SizedBox.shrink(),
            HintedIconButton(
              onPressed: navigateToAdd,
              icon: Icon(
                Icons.add,
                size: 23,
              ),
              label: "Add",
              labelStyle: TextStyle(fontSize: 13),
            ),
            IconButton(
                icon: Icon(
                  Icons.settings_outlined,
                  size: 22,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed('settings');
                }),
            SizedBox(
              width: 10,
            )
          ],
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Consumer<ProfileModel>(
                  builder: (context, model, _) {
                    var length = model.profiles.length;
                    return length > 0
                        ? Scrollbar(
                            thickness: 2,
                            child: ListView.separated(
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 14),
                              itemBuilder: (listContext, i) {
                                var profile = model.profiles[i];
                                var child = ProfileWidget(
                                  isSelected: selectedIndex == i,
                                  profile: profile,
                                  index: i,
                                  activateButtonIsDisabled: _isBusy,
                                  onDelete: () => handleDelete(
                                      context: listContext,
                                      model: model,
                                      index: i),
                                  onSelect: () =>
                                      Future.sync(() => setState(() {
                                            selectedIndex = i;
                                          })),
                                  onDeselect: () =>
                                      setState(() => selectedIndex = -1),
                                  showDeleteDialog: model
                                      .settings!.confirmationSettings!.onDelete,
                                );
                                return Padding(
                                    padding: i == length - 1
                                        ? const EdgeInsets.fromLTRB(
                                            10, 0, 10, 10)
                                        : const EdgeInsets.symmetric(
                                            horizontal: 10),
                                    child: child);
                              },
                              itemCount: length,
                            ),
                          )
                        : Align(
                            child: TextButton.icon(
                              onPressed: navigateToAdd,
                              icon: Icon(Icons.add),
                              label: Text("Add a new profile"),
                              style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateColor.resolveWith((_) =>
                                          Theme.of(context)
                                              .colorScheme
                                              .secondary)),
                            ),
                            alignment: Alignment.center,
                          );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ElevatedButton.icon(
                    icon: SizedBox(
                      height: 28,
                      width: 28,
                      child: _isBusy
                          ? Padding(
                              padding: EdgeInsets.all(6),
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ))
                          : Icon(Icons.done),
                    ),
                    onPressed: selectedIndex != -1
                        ? () {
                            handleActivate(
                                context: context,
                                index: selectedIndex,
                                model: Provider.of<ProfileModel>(context,
                                    listen: false));
                          }
                        : null,
                    label: Text(
                      "Activate",
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ButtonStyle(
                        padding: MaterialStateProperty.resolveWith(
                            (states) => EdgeInsets.symmetric(vertical: 16)))),
              )
            ],
          ),
        ));
  }
}
