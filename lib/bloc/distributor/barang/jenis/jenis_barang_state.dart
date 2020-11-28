part of 'jenis_barang_bloc.dart';

@immutable
abstract class JenisBarangState {}

class JenisBarangInitial extends JenisBarangState {}

class JenisBarangStateLoading extends JenisBarangState {}

class JenisBarangStateSuccess extends JenisBarangState {
  final Map<String, dynamic> data;

  JenisBarangStateSuccess(this.data);
}

class JenisBarangFormSuccess extends JenisBarangState {
  final Map<String, dynamic> data;

  JenisBarangFormSuccess(this.data);
}

class JenisBarangStateError extends JenisBarangState {
  final Map<String, dynamic> errors;

  JenisBarangStateError(this.errors);
}

class JenisBarangListLoaded extends JenisBarangState {
  List<JenisBarangModel> jenisBarangs;
  bool hasReachMax;

  JenisBarangListLoaded({this.jenisBarangs, this.hasReachMax});
  JenisBarangListLoaded copyWith(
      {List<JenisBarangModel> jenisBarangs, bool hasReachMax}) {
    return JenisBarangListLoaded(
        jenisBarangs: jenisBarangs ?? this.jenisBarangs,
        hasReachMax: hasReachMax ?? this.hasReachMax);
  }
}
