part of 'toko_bloc.dart';

@immutable
abstract class TokoState {}

class TokoInitial extends TokoState {}

class TokoStateLoading extends TokoState {}

class TokoStateSuccess extends TokoState {
  final Map<String, dynamic> data;

  TokoStateSuccess(this.data);
}

class TokoFormSuccess extends TokoState {
  final Map<String, dynamic> data;

  TokoFormSuccess(this.data);
}

class TokoStateError extends TokoState {
  final Map<String, dynamic> errors;

  TokoStateError(this.errors);
}
