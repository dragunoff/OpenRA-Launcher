import 'package:fpdart/fpdart.dart';
import 'package:equatable/equatable.dart';
import 'package:openra_launcher/core/error/failures.dart';

abstract class UseCase<ReturnType, Params> {
  Future<Either<Failure, ReturnType>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
