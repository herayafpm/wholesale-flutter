part of 'ukuran_barang_bloc.dart';

@immutable
abstract class UkuranBarangEvent {}

class UkuranBarangGetEvent extends UkuranBarangEvent {
  final int id;

  UkuranBarangGetEvent(this.id);
}

class UkuranBarangGetListEvent extends UkuranBarangEvent {
  final bool refresh;
  final String search;

  UkuranBarangGetListEvent({this.search = "", this.refresh = false});
}

class UkuranBarangTambahEvent extends UkuranBarangEvent {
  final UkuranBarangModel ukuranBarang;

  UkuranBarangTambahEvent(this.ukuranBarang);
}

class UkuranBarangEditEvent extends UkuranBarangEvent {
  final UkuranBarangModel ukuranBarang;

  UkuranBarangEditEvent(this.ukuranBarang);
}

class UkuranBarangDeleteEvent extends UkuranBarangEvent {
  final int id;

  UkuranBarangDeleteEvent(this.id);
}
