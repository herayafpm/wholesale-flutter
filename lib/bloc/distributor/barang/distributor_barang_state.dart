part of 'distributor_barang_bloc.dart';

@immutable
abstract class DistributorBarangState {}

class DistributorBarangInitial extends DistributorBarangState {}

class DistributorBarangStateLoading extends DistributorBarangState {}

class DistributorBarangStateSuccess extends DistributorBarangState {
  final Map<String, dynamic> data;

  DistributorBarangStateSuccess(this.data);
}

class DistributorBarangStaticStateSuccess extends DistributorBarangState {
  final Map<String, dynamic> data;

  DistributorBarangStaticStateSuccess(this.data);
}

class DistributorBarangFormSuccess extends DistributorBarangState {
  final Map<String, dynamic> data;

  DistributorBarangFormSuccess(this.data);
}

class DistributorBarangStateError extends DistributorBarangState {
  final Map<String, dynamic> errors;

  DistributorBarangStateError(this.errors);
}

class DistributorBarangListLoaded extends DistributorBarangState {
  List<DistributorBarangModel> distributorBarangs;
  bool hasReachMax;

  DistributorBarangListLoaded({this.distributorBarangs, this.hasReachMax});
  DistributorBarangListLoaded copyWith(
      {List<DistributorBarangModel> distributorBarangs, bool hasReachMax}) {
    return DistributorBarangListLoaded(
        distributorBarangs: distributorBarangs ?? this.distributorBarangs,
        hasReachMax: hasReachMax ?? this.hasReachMax);
  }
}
