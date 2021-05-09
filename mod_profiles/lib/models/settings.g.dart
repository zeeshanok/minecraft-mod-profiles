// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

extension ProfileSettingsCopyWith on ProfileSettings {
  ProfileSettings copyWith({
    ConfirmationSettings confirmations,
    bool isDarkMode,
    Directory minecraftDir,
    Directory minecraftModDir,
    Future<dynamic> Function() onUpdate,
    File profilesConfigFile,
    Directory profilesDir,
    Directory profilesModDir,
    Color themeColor,
  }) {
    return ProfileSettings(
      confirmations: confirmations ?? this.confirmationSettings,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      minecraftDir: minecraftDir ?? this.minecraftDir,
      minecraftModDir: minecraftModDir ?? this.minecraftModDir,
      onUpdate: onUpdate ?? this._onUpdate,
      profilesConfigFile: profilesConfigFile ?? this.profilesConfigFile,
      profilesDir: profilesDir ?? this.profilesDir,
      profilesModDir: profilesModDir ?? this.profilesModDir,
      themeColor: themeColor ?? this.themeColor,
    );
  }
}

extension ConfirmationSettingsCopyWith on ConfirmationSettings {
  ConfirmationSettings copyWith(
      {bool onClear, bool onDelete, Future<dynamic> Function() onUpdate}) {
    return ConfirmationSettings(
        onClear: onClear ?? this._onClear,
        onDelete: onDelete ?? this._onDelete,
        onUpdate: onUpdate ?? this._onUpdate);
  }
}
