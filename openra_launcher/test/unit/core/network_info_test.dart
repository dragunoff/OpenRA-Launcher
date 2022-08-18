import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:openra_launcher/core/network/network_info.dart';

@GenerateMocks([InternetConnectionChecker])
import 'network_info_test.mocks.dart';

void main() {
  MockInternetConnectionChecker mockInternetConnectionChecker =
      MockInternetConnectionChecker();
  NetworkInfoImpl networkInfo = NetworkInfoImpl(mockInternetConnectionChecker);

  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    networkInfo = NetworkInfoImpl(mockInternetConnectionChecker);
  });

  group('NetworkInfoImpl', () {
    group('isConnected', () {
      test(
        'should forward the call to InternetConnectionChecker.hasConnection',
        () async {
          // given
          final tHasConnectionFuture = Future.value(true);
          when(mockInternetConnectionChecker.hasConnection)
              .thenAnswer((_) => tHasConnectionFuture);

          // when
          final result = networkInfo.isConnected;

          // then
          verify(mockInternetConnectionChecker.hasConnection);
          expect(result, tHasConnectionFuture);
        },
      );
    });
  });
}
