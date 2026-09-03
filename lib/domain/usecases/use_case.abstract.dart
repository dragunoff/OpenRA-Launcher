import 'package:fpdart/fpdart.dart';
import 'package:equatable/equatable.dart';
import 'package:openra_launcher/core/error/failures.dart';

abstract class TaskUseCase<ReturnType, Params> {
  Task<ReturnType> call(Params params);
}

abstract class TaskEitherUseCase<ReturnType, Params> {
  TaskEither<Failure, ReturnType> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
