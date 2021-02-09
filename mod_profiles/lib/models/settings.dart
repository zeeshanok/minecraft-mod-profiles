import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

part 'settings.g.dart';

class ProfileSettings implements JsonConfig {
  ConfirmationSettings confirmationSettings;
  Directory minecraftModDir;
  Directory minecraftDir;
  Directory profilesDir;
  Directory profilesModDir;
  File profilesConfigFile;

  Future Function() _onUpdate;

  Color _color;
  Color get themeColor => _color ?? Colors.cyan;
  set themeColor(Color value) {
    _color = value;
    _onUpdate?.call();
  }

  bool _isDarkMode;
  bool get isDarkMode => _isDarkMode ?? true;
  set isDarkMode(bool value) {
    _isDarkMode = value;
    _onUpdate?.call();
  }

  ProfileSettings(
      {this.minecraftModDir,
      this.minecraftDir,
      this.profilesConfigFile,
      this.profilesDir,
      this.profilesModDir,
      ConfirmationSettings confirmations,
      Color themeColor,
      bool isDarkMode,
      Future Function() onUpdate}) {
    _color = themeColor;
    _isDarkMode = isDarkMode;
    _onUpdate = onUpdate;
    confirmationSettings =
        confirmations ?? ConfirmationSettings.defaultSettings();
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "isDarkMode": isDarkMode,
      "themeColor": themeColor.value,
      "confirmations": confirmationSettings.toMap()
    };
  }

  factory ProfileSettings.fromMap(Map<String, dynamic> map) {
    return ProfileSettings.defaultSettings().copyWith(
        isDarkMode: map["isDarkMode"],
        themeColor: Color(map["themeColor"]),
        confirmations: map["confirmations"] != null
            ? ConfirmationSettings.fromMap(map["confirmations"])
            : ConfirmationSettings.defaultSettings());
  }

  factory ProfileSettings.defaultSettings() {
    var env = Platform.environment;

    var minecraftDir = Directory(
        path.join(env["USERPROFILE"], "AppData", "Roaming", ".minecraft"));
    var minecraftModDir = Directory(path.join(minecraftDir.path, "mods"));
    var profilesDir = Directory(path.join(minecraftDir.path, "mod-profiles"));

    return ProfileSettings(
      profilesDir: profilesDir,
      profilesModDir: Directory(path.join(profilesDir.path, 'mods')),
      profilesConfigFile: File(path.join(profilesDir.path, "config.json")),
      minecraftDir: minecraftDir,
      minecraftModDir: minecraftModDir,
      confirmations: ConfirmationSettings.defaultSettings(),
      isDarkMode: true,
      themeColor: Colors.cyan,
    );
  }
}

class ConfirmationSettings implements JsonConfig {
  bool _onDelete;
  bool get onDelete => _onDelete;
  set onDelete(bool value) {
    _onDelete = value;
    debugPrint(value.toString());
    _onUpdate?.call();
  }

  bool _onActivate;
  bool get onActivate => _onActivate;
  set onActivate(bool value) {
    _onActivate = value;
    debugPrint(value.toString());
    _onUpdate?.call();
  }

  bool _onClear;
  bool get onClear => _onClear;
  set onClear(bool value) {
    _onClear = value;
    debugPrint(value.toString());
    _onUpdate?.call();
  }

  Future Function() _onUpdate;

  ConfirmationSettings(
      {bool onActivate,
      bool onClear,
      bool onDelete,
      Function() onUpdate}) {
    _onActivate = onActivate;
    _onClear = onClear;
    _onDelete = onDelete;
    _onUpdate = onUpdate;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "onActivate": onActivate,
      "onDelete": onDelete,
      "onClear": onClear
    };
  }

  factory ConfirmationSettings.defaultSettings() {
    return ConfirmationSettings(
        onActivate: true, onClear: true, onDelete: true);
  }

  factory ConfirmationSettings.fromMap(Map<String, dynamic> map) {
    return ConfirmationSettings(
        onActivate: map["onActivate"],
        onClear: map["onClear"],
        onDelete: map["onDelete"]);
  }
}

abstract class JsonConfig {
  Map<String, dynamic> toMap();
}
