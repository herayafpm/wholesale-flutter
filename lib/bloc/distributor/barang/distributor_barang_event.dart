part of 'distributor_barang_bloc.dart';

@immutable
abstract class DistributorBarangEvent {}

class DistributorBarangGetEvent extends DistributorBarangEvent {
  final int id;

  DistributorBarangGetEvent(this.id);
}

class DistributorBarangGetStaticEvent extends DistributorBarangEvent {}

class DistributorBarangGetListEvent extends DistributorBarangEvent {
  final bool refresh;
  final String search;

  DistributorBarangGetListEvent({this.search = "", this.refresh = false});
}

class DistributorBarangTambahEvent extends DistributorBarangEvent {
  final DistributorBarangModel distributorBarang;

  DistributorBarangTambahEvent(this.distributorBarang);
}

class DistributorBarangEditEvent extends DistributorBarangEvent {
  final DistributorBarangModel distributorBarang;

  DistributorBarangEditEvent(this.distributorBarang);
}

class DistributorBarangDeleteEvent extends DistributorBarangEvent {
  final int id;

  DistributorBarangDeleteEvent(this.id);
}
