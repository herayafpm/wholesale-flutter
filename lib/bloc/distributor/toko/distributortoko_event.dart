part of 'distributortoko_bloc.dart';

@immutable
abstract class DistributorTokoEvent {}

class DistributorTokoGetEvent extends DistributorTokoEvent {}

class DistributorTokoGetListEvent extends DistributorTokoEvent {
  final bool refresh;
  final String search;

  DistributorTokoGetListEvent({this.refresh = false, this.search = ""});
}

class DistributorTokoTambahEvent extends DistributorTokoEvent {
  final TokoModel toko;

  DistributorTokoTambahEvent(this.toko);
}

class DistributorTokoDeleteEvent extends DistributorTokoEvent {
  final int id;

  DistributorTokoDeleteEvent(this.id);
}
