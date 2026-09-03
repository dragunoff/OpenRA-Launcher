import 'package:flutter/foundation.dart';
import 'package:openra_launcher/features/updates/data/models/mod_database_info_model.dart';
import 'package:openra_launcher/features/updates/domain/entities/mod_database.dart';

@immutable
class ModDatabaseModel extends ModDatabase {
  const ModDatabaseModel({required Map<String, ModDatabaseInfoModel> mods})
      : super(mods: mods);

  factory ModDatabaseModel.fromJson(Map<String, dynamic> json) {
    final mods = <String, ModDatabaseInfoModel>{};
    final modsJson = json['mods'];

    if (modsJson is Map<String, dynamic>) {
      modsJson.forEach((modId, value) {
        if (value is Map<String, dynamic>) {
          mods[modId] = ModDatabaseInfoModel.fromJson(modId, value);
        }
      });
    }

    return ModDatabaseModel(mods: mods);
  }
}
