import 'package:flutter_test/flutter_test.dart';
import 'package:openra_launcher/features/installed_mods/services/mod_launch_service.dart';
import '../../../../testing/utils/test_utils.dart';

void main() {
  group('ProcessModLaunchService', () {
    test('should delegate launch to the process starter', () async {
      final started = <String>[];
      final fakeStarter = _FakeProcessStarter((executable, arguments) async {
        started.add(executable);
        started.addAll(arguments);
      });

      final service = ProcessModLaunchService(starter: fakeStarter);
      final mod = TestUtils.generateMod();

      await service.launch(mod);

      expect(started, [mod.launchPath, ...mod.launchArgs]);
    });

    test('should wrap launch errors in ModLaunchException', () async {
      final service =
          ProcessModLaunchService(starter: _ThrowingProcessStarter());
      final mod = TestUtils.generateMod();

      expect(service.launch(mod), throwsA(isA<ModLaunchException>()));
    });
  });
}

class _FakeProcessStarter implements LaunchProcessStarter {
  final Future<void> Function(String executable, List<String> arguments)
      _onStart;

  _FakeProcessStarter(this._onStart);

  @override
  Future<void> start(String executable, List<String> arguments) async {
    await _onStart(executable, arguments);
  }
}

class _ThrowingProcessStarter implements LaunchProcessStarter {
  @override
  Future<void> start(String executable, List<String> arguments) async {
    throw Exception('boom');
  }
}
