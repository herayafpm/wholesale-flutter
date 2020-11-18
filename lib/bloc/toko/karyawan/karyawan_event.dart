part of 'karyawan_bloc.dart';

@immutable
abstract class KaryawanEvent {}

class KaryawanGetEvent extends KaryawanEvent {}

class KaryawanGetListEvent extends KaryawanEvent {
  final bool refresh;

  KaryawanGetListEvent({this.refresh = false});
}

class KaryawanTambahEvent extends KaryawanEvent {
  final KaryawanModel karyawan;

  KaryawanTambahEvent(this.karyawan);
}

class KaryawanDeleteEvent extends KaryawanEvent {
  final int id;

  KaryawanDeleteEvent(this.id);
}
