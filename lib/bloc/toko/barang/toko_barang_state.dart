part of 'toko_barang_bloc.dart';

@immutable
abstract class TokoBarangState {}

class TokoBarangInitial extends TokoBarangState {}

class TokoBarangStateLoading extends TokoBarangState {}

class TokoBarangStateSuccess extends TokoBarangState {
  final Map<String, dynamic> data;

  TokoBarangStateSuccess(this.data);
}

class TokoBarangStaticStateSuccess extends TokoBarangState {
  final Map<String, dynamic> data;

  TokoBarangStaticStateSuccess(this.data);
}

class TokoBarangFormSuccess extends TokoBarangState {
  final Map<String, dynamic> data;

  TokoBarangFormSuccess(this.data);
}

class TokoBarangStateError extends TokoBarangState {
  final Map<String, dynamic> errors;

  TokoBarangStateError(this.errors);
}

class TokoBarangListLoaded extends TokoBarangState {
  List<TokoBarangModel> tokoBarangs;
  bool hasReachMax;

  TokoBarangListLoaded({this.tokoBarangs, this.hasReachMax});
  TokoBarangListLoaded copyWith(
      {List<TokoBarangModel> tokoBarangs, bool hasReachMax}) {
    return TokoBarangListLoaded(
        tokoBarangs: tokoBarangs ?? this.tokoBarangs,
        hasReachMax: hasReachMax ?? this.hasReachMax);
  }
}
