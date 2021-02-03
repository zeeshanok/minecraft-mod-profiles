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
  String progressMessage;
  AnimationController _controller;
  Animation<double> _animation;
  Tween<double> _tween;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
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

  void handleClear(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
          title: Text("Are you sure you want to delete all your profiles?"),
          onSubmit: (response) {
            if (response)
              Provider.of<ProfileModel>(context, listen: false).clearProfiles();
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text("Mod Profiles"),
        actions: [
          Provider.of<ProfileModel>(context).profiles.length > 0 ? HintedIconButton(
            icon: Icon(
              Icons.delete_sweep_outlined,
              color: Colors.red,
              size: 23,
            ),
            onPressed: () => handleClear(context),
            label: "Clear",
            labelStyle: TextStyle(color: Colors.red, fontSize: 13),
          ) : SizedBox.shrink(),
          HintedIconButton(
            onPressed: navigateToAdd,
            icon:
                Icon(Icons.add, size: 23, color: Theme.of(context).accentColor),
            label: "Add",
            labelStyle:
                TextStyle(color: Theme.of(context).accentColor, fontSize: 13),
          ),
          IconButton(
              icon: Icon(Icons.settings_outlined, size: 22,),
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
                    ? ListView.separated(
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 20),
                        itemBuilder: (context, i) {
                          var profile = model.profiles[i];
                          return ProfileWidget(
                            profile,
                            i,
                            onActivate: (context) async {
                              await for (var item in model.activate(i)) {
                                progressMessage = item[2];
                                _setTarget(item[0] / item[1]);
                              }
                              _setTarget(0);
                            },
                          );
                        },
                        itemCount: length,
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
                _animation.value > 0 ? Text(progressMessage) : Container(),
                SizedBox(
                  height: 5,
                ),
                LinearProgressIndicator(
                  backgroundColor: Colors.transparent,
                  value: _animation.value,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _setTarget(double val) {
    _tween.begin = _tween.end;
    _controller.reset();
    _tween.end = val;
    _controller.forward();
  }
}
