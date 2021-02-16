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
  List<String> paths = [];
  double progress = 1;
  String progressMessage = "";
  AnimationController _controller;
  Animation<double> _animation;
  Tween<double> _tween;
  double _opacity = 1;
  double _letterSpacing = 0;
  bool _isBusy = false;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _tween = Tween(begin: 0, end: 0);
    _animation = _tween
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    super.initState();
  }

  List<String> listDir(Directory dir) {
    List<String> list = [];
    for (var item in dir.listSync()) {
      list.add(item.path.replaceAll("/", "\\").split("\\").last);
    }
    return list;
  }

  void navigateToAdd() {
    Navigator.of(context).pushNamed('addProfile');
  }

  void handleClear(BuildContext context) async {
    if (Provider.of<ProfileModel>(context, listen: false)
        .settings
        .confirmationSettings
        .onClear) {
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
      {BuildContext context, ProfileModel model, int index}) async {
    setState(() => _isBusy = true);
    await for (var item in model.activate(index)) {
      progressMessage = item[2];
      _setTarget(item[0] / item[1]);
    }
    await _setTarget(0);
    setState(() {
      _opacity = 0;
    });
    await Future.delayed(
        Duration(milliseconds: 500),
        () => setState(() {
              _opacity = 1;
              _letterSpacing = 0.7;
              progressMessage = "Activated ${model.profiles[index].name}";
              _isBusy = false;
            }));
    await Future.delayed(
        Duration(seconds: 2), () => setState(() => _opacity = 0));
    await Future.delayed(Duration(milliseconds: 200),
        () => setState(() => progressMessage = ""));
    setState(() {
      _letterSpacing = 0;
      _opacity = 1;
    });
    // Yes, this is bad practice, but it works
  }

  void handleDelete({BuildContext context, ProfileModel model, int index}) {
    Provider.of<ProfileModel>(context, listen: false).removeProfile(index);
  }

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).appBarTheme.backgroundColor;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: color,
        title: Text("Mod Profiles"),
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
              // label: "Settings",
              // labelStyle: TextStyle(fontSize: 13),
              onPressed: () {
                Navigator.of(context).pushNamed('settings');
              }),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Container(
            padding: EdgeInsets.all(10),
            child: Consumer<ProfileModel>(
              builder: (context, model, _) {
                var length = model.profiles.length;
                return length > 0
                    ? Scrollbar(
                        child: ListView.separated(
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 18),
                          itemBuilder: (listContext, i) {
                            var profile = model.profiles[i];
                            return ProfileWidget(
                              profile: profile,
                              index: i,
                              activateButtonIsDisabled: _isBusy,
                              onDelete: (context) => handleDelete(
                                  context: listContext, model: model, index: i),
                              onActivate: (context) => handleActivate(
                                  context: listContext, model: model, index: i),
                              showActivateDialog: model
                                  .settings.confirmationSettings.onActivate,
                              showDeleteDialog:
                                  model.settings.confirmationSettings.onDelete,
                            );
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
                              foregroundColor: MaterialStateColor.resolveWith(
                                  (_) => Theme.of(context).accentColor)),
                        ),
                        alignment: Alignment.center,
                      );
              },
            ),
          )),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, _) => Column(
              children: [
                LinearProgressIndicator(
                  backgroundColor: Colors.transparent,
                  value: _animation.value,
                ),
                SizedBox(
                  height: 10,
                ),
                AnimatedOpacity(
                    duration: Duration(milliseconds: 200),
                    opacity: _opacity,
                    child: Text(
                      progressMessage,
                      style: TextStyle(letterSpacing: _letterSpacing),
                    )),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future _setTarget(double val) {
    _tween.begin = _tween.end;
    _controller.reset();
    _tween.end = val;
    return _controller.forward();
  }
}
