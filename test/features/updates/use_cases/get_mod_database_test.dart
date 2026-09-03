import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:openra_launcher/core/error/failures.dart';
import 'package:openra_launcher/domain/usecases/use_case.abstract.dart';
import 'package:openra_launcher/features/updates/domain/entities/mod_database.dart';
import 'package:openra_launcher/features/updates/domain/repositories/mod_database_repository.abstract.dart';
import 'package:openra_launcher/features/updates/domain/use_cases/get_mod_database.dart';

@GenerateMocks([ModDatabaseRepository])
import 'get_mod_database_test.mocks.dart';

void main() {
  provideDummy<TaskEither<ServerFailure, ModDatabase>>(
    TaskEither.left(const ServerFailure()),
  );

  MockModDatabaseRepository mockDatabaseRepository =
      MockModDatabaseRepository();
  GetModDatabase usecase = GetModDatabase(mockDatabaseRepository);

  final tDatabase = const ModDatabase(mods: {});

  setUp(() {
    mockDatabaseRepository = MockModDatabaseRepository();
    usecase = GetModDatabase(mockDatabaseRepository);
  });

  group('GetModDatabase', () {
    test('should get the mod database from the repository', () async {
      // given
      when(
        mockDatabaseRepository.getModDatabase(),
      ).thenAnswer((_) => TaskEither.right(tDatabase));

      // when
      final response = await usecase(NoParams()).run();

      // then
      expect(response, Right(tDatabase));
      verify(mockDatabaseRepository.getModDatabase());
      verifyNoMoreInteractions(mockDatabaseRepository);
    });
  });
}
