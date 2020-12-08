part of 'distributortransaksi_bloc.dart';

@immutable
abstract class DistributorTransaksiEvent {}

class DistributorTransaksiGetEvent extends DistributorTransaksiEvent {}

class DistributorTransaksiGetListEvent extends DistributorTransaksiEvent {
  final int toko_id;
  final bool refresh;
  final String search;

  DistributorTransaksiGetListEvent(
      {this.toko_id = 0, this.refresh = false, this.search = ""});
}

class DistributorTransaksiTambahEvent extends DistributorTransaksiEvent {
  final DistributorTransaksiModel transaksi;

  DistributorTransaksiTambahEvent(this.transaksi);
}

class DistributorTransaksiPelunasanEvent extends DistributorTransaksiEvent {
  final DistributorPelunasanModel pelunasan;

  DistributorTransaksiPelunasanEvent(this.pelunasan);
}
