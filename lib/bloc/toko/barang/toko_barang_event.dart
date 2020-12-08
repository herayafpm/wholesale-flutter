part of 'toko_barang_bloc.dart';

@immutable
abstract class TokoBarangEvent {}

class TokoBarangGetEvent extends TokoBarangEvent {
  final int id;

  TokoBarangGetEvent(this.id);
}

class TokoBarangGetListEvent extends TokoBarangEvent {
  final bool refresh;
  final String search;

  TokoBarangGetListEvent({this.search = "", this.refresh = false});
}

class TokoBarangEditEvent extends TokoBarangEvent {
  final TokoBarangModel tokoBarang;

  TokoBarangEditEvent(this.tokoBarang);
}

class TokoBarangDeleteEvent extends TokoBarangEvent {
  final int id;

  TokoBarangDeleteEvent(this.id);
}
