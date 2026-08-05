import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:openra_launcher/domain/usecases/use_case.abstract.dart';
import 'package:package_info_plus/package_info_plus.dart';

@lazySingleton
class GetPackageInfo implements TaskUseCase<PackageInfo, NoParams> {
  @override
  Task<PackageInfo> call(NoParams params) {
    return Task(() async => PackageInfo.fromPlatform());
  }
}
