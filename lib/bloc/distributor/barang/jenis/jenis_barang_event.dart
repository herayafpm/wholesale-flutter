part of 'jenis_barang_bloc.dart';

@immutable
abstract class JenisBarangEvent {}

class JenisBarangGetEvent extends JenisBarangEvent {
  final int id;

  JenisBarangGetEvent(this.id);
}

class JenisBarangGetListEvent extends JenisBarangEvent {
  final bool refresh;
  final String search;

  JenisBarangGetListEvent({this.search = "", this.refresh = false});
}

class JenisBarangTambahEvent extends JenisBarangEvent {
  final JenisBarangModel jenisBarang;

  JenisBarangTambahEvent(this.jenisBarang);
}

class JenisBarangEditEvent extends JenisBarangEvent {
  final JenisBarangModel jenisBarang;

  JenisBarangEditEvent(this.jenisBarang);
}

class JenisBarangDeleteEvent extends JenisBarangEvent {
  final int id;

  JenisBarangDeleteEvent(this.id);
}
