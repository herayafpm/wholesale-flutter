part of 'distributortoko_bloc.dart';

@immutable
abstract class DistributorTokoState {}

class DistributorTokoInitial extends DistributorTokoState {}

class DistributorTokoStateLoading extends DistributorTokoState {}

class DistributorTokoStateSuccess extends DistributorTokoState {
  final Map<String, dynamic> data;

  DistributorTokoStateSuccess(this.data);
}

class DistributorTokoFormSuccess extends DistributorTokoState {
  final Map<String, dynamic> data;

  DistributorTokoFormSuccess(this.data);
}

class DistributorTokoStateError extends DistributorTokoState {
  final Map<String, dynamic> errors;

  DistributorTokoStateError(this.errors);
}

class DistributorTokoListLoaded extends DistributorTokoState {
  List<TokoModel> tokos;
  bool hasReachMax;

  DistributorTokoListLoaded({this.tokos, this.hasReachMax});
  DistributorTokoListLoaded copyWith(
      {List<TokoModel> tokos, bool hasReachMax}) {
    return DistributorTokoListLoaded(
        tokos: tokos ?? this.tokos,
        hasReachMax: hasReachMax ?? this.hasReachMax);
  }
}

class DistributorBarangTokoListLoaded extends DistributorTokoState {
  List<DistributorBarangModel> barangs;
  bool hasReachMax;

  DistributorBarangTokoListLoaded({this.barangs, this.hasReachMax});
  DistributorBarangTokoListLoaded copyWith(
      {List<DistributorBarangModel> barangs, bool hasReachMax}) {
    return DistributorBarangTokoListLoaded(
        barangs: barangs ?? this.barangs,
        hasReachMax: hasReachMax ?? this.hasReachMax);
  }
}
