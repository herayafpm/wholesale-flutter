part of 'karyawan_bloc.dart';

@immutable
abstract class KaryawanState {}

class KaryawanInitial extends KaryawanState {}

class KaryawanStateLoading extends KaryawanState {}

class KaryawanStateSuccess extends KaryawanState {
  final Map<String, dynamic> data;

  KaryawanStateSuccess(this.data);
}

class KaryawanFormSuccess extends KaryawanState {
  final Map<String, dynamic> data;

  KaryawanFormSuccess(this.data);
}

class KaryawanStateError extends KaryawanState {
  final Map<String, dynamic> errors;

  KaryawanStateError(this.errors);
}

class KaryawanListLoaded extends KaryawanState {
  List<KaryawanModel> karyawans;
  bool hasReachMax;

  KaryawanListLoaded({this.karyawans, this.hasReachMax});
  KaryawanListLoaded copyWith(
      {List<KaryawanModel> karyawans, bool hasReachMax}) {
    return KaryawanListLoaded(
        karyawans: karyawans ?? this.karyawans,
        hasReachMax: hasReachMax ?? this.hasReachMax);
  }
}
