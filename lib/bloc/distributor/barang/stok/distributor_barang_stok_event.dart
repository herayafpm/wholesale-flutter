part of 'distributor_barang_stok_bloc.dart';

@immutable
abstract class DistributorBarangStokEvent {}

class DistributorBarangStokGetListEvent extends DistributorBarangStokEvent {
  final bool refresh;
  final int id;

  DistributorBarangStokGetListEvent(this.id, {this.refresh = false});
}

class DistributorBarangStokTambahEvent extends DistributorBarangStokEvent {
  final int id;
  final DistributorBarangStokModel stoks;

  DistributorBarangStokTambahEvent(this.id, this.stoks);
}
