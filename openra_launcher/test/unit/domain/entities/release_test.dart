import 'package:flutter_test/flutter_test.dart';
import 'package:openra_launcher/domain/entities/release.dart';

void main() {
  const testObj = Release(
    modId: 'test',
    id: 1,
    version: 'version',
    name: 'title',
    htmlUrl: 'https://example.com',
    isPlaytest: false,
  );

  group('Release entity', () {
    group('copyWith', () {
      test('should copy object with all fields', () {
        final a = testObj.copyWith(
          id: 2,
          version: 'version1',
          name: 'title1',
          htmlUrl: 'https://example.com/test',
        );

        expect(a.id, 2);
        expect(a.name, 'title1');
        expect(a.version, 'version1');
        expect(a.htmlUrl, 'https://example.com/test');
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
  });
}
