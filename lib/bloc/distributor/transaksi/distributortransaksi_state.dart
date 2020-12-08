part of 'distributortransaksi_bloc.dart';

@immutable
abstract class DistributorTransaksiState {}

class DistributorTransaksiInitial extends DistributorTransaksiState {}

class DistributorTransaksiStateLoading extends DistributorTransaksiState {}

class DistributorTransaksiStateSuccess extends DistributorTransaksiState {
  final Map<String, dynamic> data;

  DistributorTransaksiStateSuccess(this.data);
}

class DistributorTransaksiFormSuccess extends DistributorTransaksiState {
  final Map<String, dynamic> data;

  DistributorTransaksiFormSuccess(this.data);
}

class DistributorTransaksiStateError extends DistributorTransaksiState {
  final Map<String, dynamic> errors;

  DistributorTransaksiStateError(this.errors);
}

class DistributorTransaksiListLoaded extends DistributorTransaksiState {
  List<DistributorTransaksiModel> transaksis;
  bool hasReachMax;

  DistributorTransaksiListLoaded({this.transaksis, this.hasReachMax});
  DistributorTransaksiListLoaded copyWith(
      {List<DistributorTransaksiModel> transaksis, bool hasReachMax}) {
    return DistributorTransaksiListLoaded(
        transaksis: transaksis ?? this.transaksis,
        hasReachMax: hasReachMax ?? this.hasReachMax);
  }
}
