part of 'distributorpenjualan_bloc.dart';

@immutable
abstract class DistributorPenjualanState {}

class DistributorPenjualanInitial extends DistributorPenjualanState {}

class DistributorPenjualanStateLoading extends DistributorPenjualanState {}

class DistributorPenjualanStateSuccess extends DistributorPenjualanState {
  final Map<String, dynamic> data;

  DistributorPenjualanStateSuccess(this.data);
}

class DistributorPenjualanStateError extends DistributorPenjualanState {
  final Map<String, dynamic> errors;

  DistributorPenjualanStateError(this.errors);
}
