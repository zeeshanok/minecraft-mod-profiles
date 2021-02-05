import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mod_profiles/models/profile.dart';
import 'package:mod_profiles/models/settings.dart';
import 'package:mod_profiles/utils/consts.dart';
import 'package:path/path.dart' as path;

class ProfileModel extends ChangeNotifier {
  List<Profile> _profiles = [];

  ProfileSettings settings;

  UnmodifiableListView<Profile> get profiles => UnmodifiableListView(_profiles);

  ProfileModel() {
    MinecraftDirStatus status;
    var env = Platform.environment;

    var minecraftDir = Directory(
        path.join(env["USERPROFILE"], "AppData", "Roaming", ".minecraft"));
    var minecraftModDir = Directory(path.join(minecraftDir.path, "mods"));
    var profilesDir = Directory(path.join(minecraftDir.path, "mod-profiles"));

    if (env.containsKey("USERPROFILE")) {
      if (minecraftModDir.existsSync())
        status = MinecraftDirStatus.ModsDir;
      else if (minecraftDir.existsSync())
        status = MinecraftDirStatus.MinecraftDir;
      else
        status = MinecraftDirStatus.NoMinecraftDir;
    } else {
      status = MinecraftDirStatus.NoUserDir;
    }
    settings = ProfileSettings(
      dirStatus: status,
      profilesDir: profilesDir,
      profilesModDir: Directory(path.join(profilesDir.path, 'mods')),
      profilesConfigFile: File(path.join(profilesDir.path, "config.json")),
      minecraftDir: minecraftDir,
      minecraftModDir: minecraftModDir,
    );
    _read().then((value) async => await _update());
  }

  Future<void> addProfile(Profile profile) async {
    return Future(() async {
      List<String> fileNames = [];
      for (var fileName in profile.mods) {
        var file = await File(fileName).copy(
            path.join(settings.profilesModDir.path, getFileName(fileName)));
        fileNames.add(getFileName(file.path));
      }
      _profiles.add(Profile(profile.name, fileNames));
      await _update();
    });
  }

  Future editProfile(int index, Profile newProfile) async {
    var newFiles = await _copyToProfileModsDir(newProfile.mods);
    _profiles[index] = Profile(newProfile.name, newFiles);
    await _update();
  }

  void removeProfile(int index) async {
    _profiles.removeAt(index);
    await _update();
  }

  void clearProfiles() async {
    _profiles.clear();
    await _update();
  }

  Stream<List<dynamic>> activate(int index) async* {
    var profile = _profiles[index];
    var minecraftDirMods = await settings.minecraftModDir.list().toList();
    int total = minecraftDirMods.length + profile.mods.length;
    int count = 0;
    for (var mod in minecraftDirMods) {
      count += 1;
      yield [count, total, "Deleting ${getFileName(mod.path)} in mods folder"];
      await mod.delete();
    }
    for (var mod in profile.mods) {
      count += 1;
      yield [count, total, "Copying ${getFileName(mod)} into mods folder"];
      await File(path.join(settings.profilesModDir.path, mod))
          .copy(path.join(settings.minecraftModDir.path, mod));
    }
  }

  Future<List<String>> _copyToProfileModsDir(List<String> fileNames) async {
    List<String> newFileNames = [];
    for (var fileName in fileNames) {
      var file = await File(fileName)
          .copy(path.join(settings.profilesModDir.path, getFileName(fileName)));
      newFileNames.add(file.path);
    }
    return newFileNames;
  }

  String _generateConfig() {
    return JsonEncoder.withIndent("   ").convert({
      "profiles": _profiles.map((e) => e.toMap()).toList(),
      "isDarkMode": settings.isDarkMode,
      "themeColor": settings.themeColor.value,
    });
  }

  Future _update() async {
    _createIfNotExists();
    var json = _generateConfig();
    await settings.profilesConfigFile.writeAsString(json);
    await _read();
  }

  void _createIfNotExists() async {
    if (!(await settings.profilesConfigFile.exists())) {
      await settings.profilesConfigFile.create(recursive: true);
      await settings.profilesConfigFile.writeAsString(jsonEncode({
        "profiles": [],
      }));
      debugPrint("created config file in ${settings.profilesConfigFile.path}");
    }
    if (!(await settings.profilesModDir.exists())) {
      await settings.profilesModDir.create();
    }
  }

  Future _read() async {
    _createIfNotExists();
    String content = await settings.profilesConfigFile.readAsString();
    try {
      Map<String, dynamic> json = jsonDecode(content);

      var profilesJson = json["profiles"];
      List<Profile> profiles = [];

      for (var item in profilesJson) {
        profiles.add(Profile.fromMap(item));
      }

      _profiles = [...profiles];

      if (json.containsKey("themeColor")) {
        var color = Color(json["themeColor"]);
        settings.themeColor = color;
      }

      settings.isDarkMode = json["isDarkMode"] ?? true;
    } on FormatException {
      await settings.profilesConfigFile.writeAsString(_generateConfig());
    } finally {
      notifyListeners();
    }
  }

  String getFullProfileModPath(String fileName) {
    if (File(fileName).isAbsolute) return fileName;
    return path.join(settings.profilesModDir.path, fileName);
  }

  void setThemeColor(Color color) {
    settings.themeColor = color;
    _update();
  }

  void setDarkMode(bool isDark) {
    settings.isDarkMode = isDark;
    _update();
  }
}
