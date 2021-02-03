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
  // ThemeData generateTheme(ProfileModel model) {
  //   return (model.isDarkMode ? ThemeData.dark() : ThemeData.light()).copyWith(
  //     appBarTheme: AppBarTheme(
  //       backgroundColor: model.isDarkMode ? Colors.transparent : model.themeColor
  //     ),
  //     scaffoldBackgroundColor: model.isDarkMode ? Colors.black : null
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileModel>(builder: (context, model, child) {
      return MaterialApp(
        title: 'Mod Profiles',
        theme: (model.isDarkMode
            ? ThemeData.dark().copyWith(
                accentColor: model.themeColor,
                scaffoldBackgroundColor: Colors.black,
                appBarTheme: AppBarTheme(backgroundColor: Colors.transparent),
              )
            : ThemeData.light().copyWith(
                appBarTheme: AppBarTheme(backgroundColor: model.themeColor),
                accentColor: model.themeColor)).copyWith(
                  elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                      primary: model.themeColor
                    )
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      primary: model.themeColor
                    )
                  ),
                  outlinedButtonTheme: OutlinedButtonThemeData(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: model.themeColor),
                      primary: model.themeColor,
                      // onSurface: model.themeColor
                    )
                  )
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
