import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:openra_launcher/features/updates/data/models/mod_database_info_model.dart';

void main() {
  group('ModDatabaseInfoModel.fromJson', () {
    test('parses metadata and stable/playtest releases', () {
      final model = ModDatabaseInfoModel.fromJson('ra', {
        'title': 'Red Alert',
        'description': 'The classic.',
        'homepage': 'https://moddb.com/ra',
        'repo_url': 'https://github.com/OpenRA/OpenRA',
        'stable': {
          'id': 1,
          'name': 'release',
          'tag_name': '1.0.0',
          'prerelease': false,
          'html_url': 'https://github.com/OpenRA/OpenRA/releases/tag/1.0.0',
        },
        'playtest': {
          'id': 2,
          'name': '',
          'tag_name': '2.0.0',
          'prerelease': true,
          'html_url': 'https://github.com/OpenRA/OpenRA/releases/tag/2.0.0',
        },
      });

      expect(model.modId, 'ra');
      expect(model.title, 'Red Alert');
      expect(model.description, 'The classic.');
      expect(model.homepage, 'https://moddb.com/ra');
      expect(model.repoUrl, 'https://github.com/OpenRA/OpenRA');

      expect(model.stable?.version, '1.0.0');
      expect(model.stable?.isPlaytest, isFalse);
      expect(model.stable?.name, 'release');
      expect(model.playtest?.version, '2.0.0');
      expect(model.playtest?.isPlaytest, isTrue);
    });

    test('defaults title and treats absent optional fields as null', () {
      final model = ModDatabaseInfoModel.fromJson('ra', {});

      expect(model.title, '');
      expect(model.description, isNull);
      expect(model.homepage, isNull);
      expect(model.repoUrl, isNull);
      expect(model.icon, isNull);
      expect(model.stable, isNull);
      expect(model.playtest, isNull);
    });

    test('does not build releases for null stable/playtest entries', () {
      final model = ModDatabaseInfoModel.fromJson('ra', {
        'stable': null,
        'playtest': null,
      });

      expect(model.stable, isNull);
      expect(model.playtest, isNull);
    });

    test('decodes a base64 data-uri icon', () {
      final model = ModDatabaseInfoModel.fromJson('ra', {
        'icon': 'data:image/png;base64,AAAA',
      });

      expect(model.icon, isA<Uint8List>());
      expect(model.icon, [0, 0, 0]);
    });

    test('leaves icon null when missing or malformed', () {
      final missing = ModDatabaseInfoModel.fromJson('ra', {});
      final malformed = ModDatabaseInfoModel.fromJson('ra', {'icon': ''});

      expect(missing.icon, isNull);
      expect(malformed.icon, isNull);
    });
  });
}
