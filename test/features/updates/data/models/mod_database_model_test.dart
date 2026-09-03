import 'package:flutter_test/flutter_test.dart';
import 'package:openra_launcher/features/updates/data/models/mod_database_model.dart';

void main() {
  group('ModDatabaseModel.fromJson', () {
    test('builds a map of mod info keyed by mod id', () {
      final model = ModDatabaseModel.fromJson({
        'version': 1,
        'mods': {
          'ra': {'title': 'Red Alert', 'stable': null, 'playtest': null},
          'cnc': {
            'title': 'Command & Conquer',
            'stable': null,
            'playtest': null,
          },
        },
      });

      expect(model.mods.keys, containsAll(['ra', 'cnc']));
      expect(model.mods['ra']!.title, 'Red Alert');
      expect(model.mods['cnc']!.title, 'Command & Conquer');
    });

    test('returns empty map when there is no mods field', () {
      final model = ModDatabaseModel.fromJson({'version': 1});

      expect(model.mods, isEmpty);
    });

    test('returns empty map for an empty database', () {
      final model = ModDatabaseModel.fromJson({});

      expect(model.mods, isEmpty);
    });
  });
}
