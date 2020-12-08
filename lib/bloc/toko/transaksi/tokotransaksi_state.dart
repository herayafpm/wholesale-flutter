part of 'tokotransaksi_bloc.dart';

@immutable
abstract class TokoTransaksiState {}

class TokoTransaksiInitial extends TokoTransaksiState {}

class TokoTransaksiStateLoading extends TokoTransaksiState {}

class TokoTransaksiStateSuccess extends TokoTransaksiState {
  final Map<String, dynamic> data;

  TokoTransaksiStateSuccess(this.data);
}

class TokoTransaksiFormSuccess extends TokoTransaksiState {
  final Map<String, dynamic> data;

  TokoTransaksiFormSuccess(this.data);
}

class TokoTransaksiStateError extends TokoTransaksiState {
  final Map<String, dynamic> errors;

  TokoTransaksiStateError(this.errors);
}

class TokoTransaksiListLoaded extends TokoTransaksiState {
  List<TokoTransaksiModel> transaksis;
  bool hasReachMax;

  TokoTransaksiListLoaded({this.transaksis, this.hasReachMax});
  TokoTransaksiListLoaded copyWith(
      {List<TokoTransaksiModel> transaksis, bool hasReachMax}) {
    return TokoTransaksiListLoaded(
        transaksis: transaksis ?? this.transaksis,
        hasReachMax: hasReachMax ?? this.hasReachMax);
  }
}
