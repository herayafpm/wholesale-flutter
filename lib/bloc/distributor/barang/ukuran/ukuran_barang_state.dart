part of 'ukuran_barang_bloc.dart';

@immutable
abstract class UkuranBarangState {}

class UkuranBarangInitial extends UkuranBarangState {}

class UkuranBarangStateLoading extends UkuranBarangState {}

class UkuranBarangStateSuccess extends UkuranBarangState {
  final Map<String, dynamic> data;

  UkuranBarangStateSuccess(this.data);
}

class UkuranBarangFormSuccess extends UkuranBarangState {
  final Map<String, dynamic> data;

  UkuranBarangFormSuccess(this.data);
}

class UkuranBarangStateError extends UkuranBarangState {
  final Map<String, dynamic> errors;

  UkuranBarangStateError(this.errors);
}

class UkuranBarangListLoaded extends UkuranBarangState {
  List<UkuranBarangModel> ukuranBarangs;
  bool hasReachMax;

  UkuranBarangListLoaded({this.ukuranBarangs, this.hasReachMax});
  UkuranBarangListLoaded copyWith(
      {List<UkuranBarangModel> ukuranBarangs, bool hasReachMax}) {
    return UkuranBarangListLoaded(
        ukuranBarangs: ukuranBarangs ?? this.ukuranBarangs,
        hasReachMax: hasReachMax ?? this.hasReachMax);
  }
}
