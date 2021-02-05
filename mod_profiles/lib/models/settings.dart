import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mod_profiles/models/profile.dart';

class ProfileSettings implements JsonConfig {
  ConfirmationSettings confirmationSettings;
  Directory minecraftModDir;
  Directory minecraftDir;
  Directory profilesDir;
  Directory profilesModDir;
  File profilesConfigFile;
  MinecraftDirStatus dirStatus;

  Color _color;
  Color get themeColor => _color ?? Colors.cyan;
  set themeColor(Color value) => _color = value;

  bool _isDarkMode;
  bool get isDarkMode => _isDarkMode ?? true;
  set isDarkMode(bool value) => _isDarkMode = value;

  ProfileSettings(
      {this.confirmationSettings,
      this.minecraftModDir,
      this.minecraftDir,
      this.dirStatus,
      this.profilesConfigFile,
      this.profilesDir,
      this.profilesModDir,
      Color themeColor,
      bool isDarkMode}) {
    _color = themeColor;
    _isDarkMode = isDarkMode;
  }

  @override
  Map<String, dynamic> generateConfig() {
    return {
      "isDarkMode": isDarkMode,
      "themeColor": themeColor.value,
      "confirmations": confirmationSettings.generateConfig()
    };
  }
}

class ConfirmationSettings implements JsonConfig {
  bool onDelete;
  bool onActivate;
  bool onClear;

  ConfirmationSettings({this.onActivate, this.onClear, this.onDelete});

  @override
  Map<String, dynamic> generateConfig() {
    return {"onDelete": onDelete, "onActivate": onActivate, "onClear": onClear};
  }
}

abstract class JsonConfig {
  Map<String, dynamic> generateConfig();
}
