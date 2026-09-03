import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/features/updates/data/data_sources/mod_database_data_source.dart';
import 'package:openra_launcher/features/updates/data/models/mod_database_model.dart';
import 'package:openra_launcher/features/updates/data/repositories/mod_database_repository_impl.dart';
import 'package:openra_launcher/features/updates/domain/entities/mod_database.dart';

@GenerateMocks([ModDatabaseDataSource])
import 'mod_database_repository_impl_test.mocks.dart';

void main() {
  provideDummy<TaskEither<ServerFailure, ModDatabase>>(
    TaskEither.left(const ServerFailure()),
  );
  MockModDatabaseDataSource mockDataSource = MockModDatabaseDataSource();
  ModDatabaseRepositoryImpl repository = ModDatabaseRepositoryImpl(
    dataSource: mockDataSource,
  );

  setUp(() {
    reset(mockDataSource);
  });

  group('ModDatabaseRepositoryImpl', () {
    group('getModDatabase', () {
      final tDatabase = ModDatabaseModel.fromJson({
        'ra': {
          'title': 'Red Alert',
          'stable': {
            'id': 1,
            'name': '',
            'tag_name': '1.0.0',
            'prerelease': false,
            'html_url': 'https://example.com/1.0.0',
          },
        },
      });

      test('should get the mod database from the data source', () async {
        // given
        when(
          mockDataSource.getModDatabase(),
        ).thenAnswer((_) => TaskEither.right(tDatabase));

        // when
        final result = await repository.getModDatabase().run();

        // then
        verify(mockDataSource.getModDatabase());
        expect(result, Right(tDatabase));
      });

      test('should return a failure when an exception is thrown', () async {
        // given
        when(
          mockDataSource.getModDatabase(),
        ).thenAnswer((_) => TaskEither.left(const ServerFailure()));

        // when
        final result = await repository.getModDatabase().run();

        // then
        verify(mockDataSource.getModDatabase());
        result.match(
          (left) => expect(left, isA<ServerFailure>()),
          (_) => fail('Expected Either.Left'),
        );
      });
    });
  });
}
