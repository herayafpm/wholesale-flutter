part of 'tokotransaksi_bloc.dart';

@immutable
abstract class TokoTransaksiEvent {}

class TokoTransaksiGetEvent extends TokoTransaksiEvent {}

class TokoTransaksiGetListEvent extends TokoTransaksiEvent {
  final int toko_id;
  final bool refresh;
  final String search;

  TokoTransaksiGetListEvent(
      {this.toko_id = 0, this.refresh = false, this.search = ""});
}

class TokoTransaksiTambahEvent extends TokoTransaksiEvent {
  final TokoTransaksiModel transaksi;

  TokoTransaksiTambahEvent(this.transaksi);
}
