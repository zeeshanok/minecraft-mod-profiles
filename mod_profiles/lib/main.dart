import 'package:flutter/material.dart';
import 'package:mod_profiles/models/profileModel.dart';
import 'package:mod_profiles/pages/addProfile.dart';
import 'package:mod_profiles/pages/settings.dart';
import 'package:mod_profiles/utils/consts.dart';
import 'package:mod_profiles/pages/home.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => ProfileModel(), child: ModProfileApp()));
}

class ModProfileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileModel>(builder: (context, model, child) {
      return MaterialApp(
        title: 'Mod Profiles',
        theme: (model.settings.isDarkMode
                ? ThemeData.dark().copyWith(
                    accentColor: model.settings.themeColor,
                    scaffoldBackgroundColor: Colors.black,
                  )
                : ThemeData.light().copyWith(
                    accentColor: model.settings.themeColor))
            .copyWith(
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(primary: model.settings.themeColor)),
          textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(primary: model.settings.themeColor)),
          outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
            side: BorderSide(color: model.settings.themeColor),
            primary: model.settings.themeColor,
          )),
          switchTheme: SwitchThemeData(
              thumbColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected) ||
                states.contains(MaterialState.focused)) {
              return model.settings.themeColor;
            } else {
              return null;
            }
          }), trackColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected) ||
                states.contains(MaterialState.focused)) {
              return model.settings.themeColor.withAlpha(150);
            } else {
              return null;
            }
          })),
          appBarTheme: AppBarTheme(
            elevation: 0,
            backgroundColor: model.settings.isDarkMode ? Colors.transparent: model.settings.themeColor
          ),
          dialogBackgroundColor: model.settings.isDarkMode ? Colors.black : ThemeData.light().scaffoldBackgroundColor
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
    });
  }
}
