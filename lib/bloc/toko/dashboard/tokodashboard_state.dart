part of 'tokodashboard_bloc.dart';

@immutable
abstract class TokoDashboardState {}

class TokoDashboardInitial extends TokoDashboardState {}

class TokoDashboardStateLoading extends TokoDashboardState {}

class TokoDashboardStateSuccess extends TokoDashboardState {
  final Map<String, dynamic> data;

  TokoDashboardStateSuccess(this.data);
}

class TokoDashboardStateError extends TokoDashboardState {
  final Map<String, dynamic> errors;

  TokoDashboardStateError(this.errors);
}
