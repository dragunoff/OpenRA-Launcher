import 'package:flutter_test/flutter_test.dart';
import 'package:openra_launcher/features/updates/domain/entities/release.dart';

void main() {
  const testObj = Release(
    modId: 'test',
    id: 1,
    version: 'version',
    name: 'title',
    htmlUrl: 'https://example.com',
    isPlaytest: false,
    body: '# Release Notes\n- Initial release',
  );

  group('Release entity', () {
    group('copyWith', () {
      test('should copy object with all fields', () {
        final a = testObj.copyWith(
          id: 2,
          version: 'version1',
          name: 'title1',
          htmlUrl: 'https://example.com/test',
          body: '# Updated\n- New feature',
        );

        expect(a.id, 2);
        expect(a.name, 'title1');
        expect(a.version, 'version1');
        expect(a.htmlUrl, 'https://example.com/test');
        expect(a.body, '# Updated\n- New feature');
      });
    });

    group('Identity', () {
      test('should tell if objects are identical', () {
        final a = testObj.copyWith();
        final b = testObj.copyWith();

        expect(a == b, true);
      });

      test('should tell if objects are not identical', () {
        final a = testObj.copyWith();
        final b = testObj.copyWith(id: 2);

        expect(a == b, false);
      });
    });

    group('hasReleaseNotes', () {
      Release withNotes({String name = '', String? body}) => Release(
            modId: 'test',
            id: 1,
            version: 'version',
            name: name,
            htmlUrl: 'https://example.com',
            isPlaytest: false,
            body: body,
          );

      test('returns true when both name and body are present', () {
        expect(withNotes(name: 'Release', body: 'Notes').hasReleaseNotes, true);
      });

      test('returns true when only the name is present', () {
        expect(withNotes(name: 'Release').hasReleaseNotes, true);
      });

      test('returns true when only the body is present', () {
        expect(withNotes(body: 'Notes').hasReleaseNotes, true);
      });

      test('returns false when name and body are both empty', () {
        expect(withNotes(name: '').hasReleaseNotes, false);
        expect(withNotes(name: '', body: '').hasReleaseNotes, false);
        expect(withNotes(name: '', body: null).hasReleaseNotes, false);
        expect(withNotes(name: '   ', body: '   ').hasReleaseNotes, false);
      });
    });

    group('hasBody', () {
      test('returns true when the body is non-empty', () {
        expect(testObj.hasBody, true);
        expect(
          testObj.copyWith(body: '   notes   ').hasBody,
          true,
        );
      });

      test('returns false when the body is null or blank', () {
        expect(testObj.copyWith(body: null).hasBody, false);
        expect(testObj.copyWith(body: '').hasBody, false);
        expect(testObj.copyWith(body: '   ').hasBody, false);
      });
    });
  });
}
