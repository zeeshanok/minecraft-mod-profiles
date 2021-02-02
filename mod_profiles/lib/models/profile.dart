import 'dart:convert';

class Profile {
  String name;
  List<String> mods;

  Profile(this.name, this.mods);

  List<String> get modsSorted {
    var list = [...mods];
    list.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return list;
  }

  static Profile fromMap(Map<String, dynamic> map) {
    return Profile(map["name"], map["mods"].cast<String>());
  }

  Map<String, dynamic> toMap() {
    return {"name": name, "mods": mods.toSet().toList()};
  }

  static fromJSON(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    return Profile.fromMap(map);
  }

  String toJSON() {
    return jsonEncode(toMap());
  }

  @override
  String toString() {
    return name + " " + mods.toString();
  }
}

enum MinecraftDirStatus { ModsDir, MinecraftDir, NoMinecraftDir, NoUserDir }
enum ProfileEditMode { Edit, Create, View }
