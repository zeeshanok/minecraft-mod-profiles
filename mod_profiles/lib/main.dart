import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mod_profiles/models/profileModel.dart';
import 'package:mod_profiles/pages/addProfile.dart';
import 'package:mod_profiles/pages/editProfile.dart';
import 'package:mod_profiles/pages/settings.dart';
import 'package:mod_profiles/utils/consts.dart';
import 'package:provider/provider.dart';

import 'pages/homepage.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => ProfileModel(), child: ModProfileApp()));
}

class ModProfileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mod Profiles',
      theme: ThemeData.dark().copyWith(
        accentColor: Colors.cyan,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(backgroundColor: Colors.transparent),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: 'home',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case 'home':
            return createRoute(HomePage());
          case 'addProfile':
            return createRoute(AddProfilePage());
          case 'settings':
            return createRoute(SettingsPage());
        }
      },
    );
  }
}
