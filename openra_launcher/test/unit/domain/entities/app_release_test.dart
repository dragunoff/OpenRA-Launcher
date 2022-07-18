import 'package:flutter_test/flutter_test.dart';
import 'package:openra_launcher/domain/entities/app_release.dart';

void main() {
  const testObj = AppRelease(
    id: 1,
    version: 'version',
    name: 'title',
    htmlUrl: 'https://example.com',
  );

  group('AppRelease entity', () {
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
        var a = testObj.copyWith();
        var b = testObj.copyWith();

        expect(a == b, true);
      });

      test('should tell if objects are not identical', () {
        var a = testObj.copyWith();
        var b = testObj.copyWith(id: 2);

        expect(a == b, false);
      });
    });
  });
}
