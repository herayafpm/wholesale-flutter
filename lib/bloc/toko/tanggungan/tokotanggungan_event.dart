part of 'tokotanggungan_bloc.dart';

@immutable
abstract class TokoTanggunganEvent {}

class TokoTanggunganGetEvent extends TokoTanggunganEvent {}

class TokoTanggunganGetListEvent extends TokoTanggunganEvent {
  final bool refresh;

  TokoTanggunganGetListEvent({this.refresh = false});
}

class TokoTanggunganTambahEvent extends TokoTanggunganEvent {
  final DistributorTransaksiModel tanggungan;

  TokoTanggunganTambahEvent(this.tanggungan);
}

class TokoTanggunganPelunasanEvent extends TokoTanggunganEvent {
  final DistributorPelunasanModel pelunasan;

  TokoTanggunganPelunasanEvent(this.pelunasan);
}
