import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mod_profiles/models/profile.dart';
import 'package:mod_profiles/utils/consts.dart';
import 'package:path/path.dart' as path;

class ProfileModel extends ChangeNotifier {
  List<Profile> _profiles = [];

  Directory minecraftModDir;
  Directory minecraftDir;
  Directory profilesDir;
  Directory profilesModDir;
  File profilesConfigFile;
  MinecraftDirStatus dirStatus;

  Color _color;
  Color get themeColor => _color ?? Colors.cyan;

  bool _isDarkMode;
  bool get isDarkMode => _isDarkMode ?? true;

  UnmodifiableListView<Profile> get profiles => UnmodifiableListView(_profiles);

  ProfileModel() {
    MinecraftDirStatus status;
    var env = Platform.environment;
    if (env.containsKey("USERPROFILE")) {
      minecraftDir = Directory(
          path.join(env["USERPROFILE"], "AppData", "Roaming", ".minecraft"));
      minecraftModDir = Directory(path.join(minecraftDir.path, "mods"));
      if (minecraftModDir.existsSync())
        status = MinecraftDirStatus.ModsDir;
      else if (minecraftDir.existsSync())
        status = MinecraftDirStatus.MinecraftDir;
      else
        status = MinecraftDirStatus.NoMinecraftDir;
    } else {
      status = MinecraftDirStatus.NoUserDir;
    }
    dirStatus = status;
    profilesDir = Directory(path.join(minecraftDir.path, "mod-profiles"));
    profilesModDir = Directory(path.join(profilesDir.path, 'mods'));
    profilesConfigFile = File(path.join(profilesDir.path, "config.json"));
    _read().then((value) async => await _update());
  }

  Future<void> addProfile(Profile profile) async {
    return Future(() async {
      List<String> fileNames = [];
      for (var fileName in profile.mods) {
        var file = await File(fileName)
            .copy(path.join(profilesModDir.path, getFileName(fileName)));
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
    var minecraftDirMods = await minecraftModDir.list().toList();
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
      await File(path.join(profilesModDir.path, mod))
          .copy(path.join(minecraftModDir.path, mod));
    }
  }

  Future<List<String>> _copyToProfileModsDir(List<String> fileNames) async {
    List<String> newFileNames = [];
    for (var fileName in fileNames) {
      var file = await File(fileName)
          .copy(path.join(profilesModDir.path, getFileName(fileName)));
      newFileNames.add(file.path);
    }
    return newFileNames;
  }

  String _generateConfig() {
    return JsonEncoder.withIndent("   ").convert({
      "profiles": _profiles.map((e) => e.toMap()).toList(),
      "isDarkMode": _isDarkMode,
      "themeColor": _color.value,
    });
  }

  Future _update() async {
    _createIfNotExists();
    var json = _generateConfig();
    await profilesConfigFile.writeAsString(json);
    await _read();
  }

  void _createIfNotExists() async {
    if (!(await profilesConfigFile.exists())) {
      await profilesConfigFile.create(recursive: true);
      await profilesConfigFile.writeAsString(jsonEncode({
        "profiles": [],
      }));
      debugPrint("created config file in ${profilesConfigFile.path}");
    }
    if (!(await profilesModDir.exists())) {
      await profilesModDir.create();
    }
  }

  Future _read() async {
    _createIfNotExists();
    String content = await profilesConfigFile.readAsString();
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
        _color = color;
      }

      _isDarkMode = json["isDarkMode"] ?? true;
    } on FormatException {
      await profilesConfigFile.writeAsString(_generateConfig());
    } finally {
      notifyListeners();
    }
  }

  String getFullProfileModPath(String fileName) {
    if (File(fileName).isAbsolute) return fileName;
    return path.join(profilesModDir.path, fileName);
  }

  void setColor(Color color) {
    _color = color;
    _update();
    // notifyListeners();
  }

  void setDarkMode(bool isDark) {
    _isDarkMode = isDark;
    _update();
  }
}
