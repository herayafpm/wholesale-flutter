part of 'toko_bloc.dart';

@immutable
abstract class TokoEvent {}

class TokoGetEvent extends TokoEvent {}

class TokoUpdateEvent extends TokoEvent {
  final TokoModel toko;

  TokoUpdateEvent(this.toko);
}
