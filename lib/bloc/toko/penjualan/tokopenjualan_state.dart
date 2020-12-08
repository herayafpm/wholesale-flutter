part of 'tokopenjualan_bloc.dart';

@immutable
abstract class TokoPenjualanState {}

class TokoPenjualanInitial extends TokoPenjualanState {}

class TokoPenjualanStateLoading extends TokoPenjualanState {}

class TokoPenjualanStateSuccess extends TokoPenjualanState {
  final Map<String, dynamic> data;

  TokoPenjualanStateSuccess(this.data);
}

class TokoPenjualanStateError extends TokoPenjualanState {
  final Map<String, dynamic> errors;

  TokoPenjualanStateError(this.errors);
}
