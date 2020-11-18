part of 'distributor_barang_stok_bloc.dart';

@immutable
abstract class DistributorBarangStokState {}

class DistributorBarangStokInitial extends DistributorBarangStokState {}

class DistributorBarangStokStateLoading extends DistributorBarangStokState {}

class DistributorBarangStokStateSuccess extends DistributorBarangStokState {
  final Map<String, dynamic> data;

  DistributorBarangStokStateSuccess(this.data);
}

class DistributorBarangStokFormSuccess extends DistributorBarangStokState {
  final Map<String, dynamic> data;

  DistributorBarangStokFormSuccess(this.data);
}

class DistributorBarangStokStateError extends DistributorBarangStokState {
  final Map<String, dynamic> errors;

  DistributorBarangStokStateError(this.errors);
}

class DistributorBarangStokListLoaded extends DistributorBarangStokState {
  List<DistributorBarangStokModel> stoks;
  bool hasReachMax;

  DistributorBarangStokListLoaded({this.stoks, this.hasReachMax});
  DistributorBarangStokListLoaded copyWith(
      {List<DistributorBarangStokModel> stoks, bool hasReachMax}) {
    return DistributorBarangStokListLoaded(
        stoks: stoks ?? this.stoks,
        hasReachMax: hasReachMax ?? this.hasReachMax);
  }
}
