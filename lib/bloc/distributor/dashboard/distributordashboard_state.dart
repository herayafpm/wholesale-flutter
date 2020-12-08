part of 'distributordashboard_bloc.dart';

@immutable
abstract class DistributorDashboardState {}

class DistributorDashboardInitial extends DistributorDashboardState {}

class DistributorDashboardStateLoading extends DistributorDashboardState {}

class DistributorDashboardStateSuccess extends DistributorDashboardState {
  final Map<String, dynamic> data;

  DistributorDashboardStateSuccess(this.data);
}

class DistributorDashboardStateError extends DistributorDashboardState {
  final Map<String, dynamic> errors;

  DistributorDashboardStateError(this.errors);
}
