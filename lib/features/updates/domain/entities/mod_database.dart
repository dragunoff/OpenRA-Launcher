import 'package:flutter/foundation.dart';
import 'package:openra_launcher/features/updates/domain/entities/mod_database_info.dart';

@immutable
class ModDatabase {
  final Map<String, ModDatabaseInfo> mods;

  const ModDatabase({required this.mods});
}
