part of 'tokotanggungan_bloc.dart';

@immutable
abstract class TokoTanggunganState {}

class TokoTanggunganInitial extends TokoTanggunganState {}

class TokoTanggunganStateLoading extends TokoTanggunganState {}

class TokoTanggunganStateSuccess extends TokoTanggunganState {
  final Map<String, dynamic> data;

  TokoTanggunganStateSuccess(this.data);
}

class TokoTanggunganStateError extends TokoTanggunganState {
  final Map<String, dynamic> errors;

  TokoTanggunganStateError(this.errors);
}

class TokoTanggunganListLoaded extends TokoTanggunganState {
  List<DistributorTransaksiModel> tanggungans;
  bool hasReachMax;

  TokoTanggunganListLoaded({this.tanggungans, this.hasReachMax});
  TokoTanggunganListLoaded copyWith(
      {List<DistributorTransaksiModel> tanggungans, bool hasReachMax}) {
    return TokoTanggunganListLoaded(
        tanggungans: tanggungans ?? this.tanggungans,
        hasReachMax: hasReachMax ?? this.hasReachMax);
  }
}
