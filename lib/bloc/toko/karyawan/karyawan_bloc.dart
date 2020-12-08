import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wholesale/models/karyawan_model.dart';
import 'package:wholesale/repositories/toko/karyawan_repository.dart';

part 'karyawan_event.dart';
part 'karyawan_state.dart';

class KaryawanBloc extends Bloc<KaryawanEvent, KaryawanState> {
  KaryawanBloc() : super(KaryawanInitial());

  @override
  Stream<KaryawanState> mapEventToState(
    KaryawanEvent event,
  ) async* {
    if (event is KaryawanGetListEvent) {
      List<KaryawanModel> karyawans = [];
      if (state is KaryawanInitial || event.refresh) {
        Map<String, dynamic> res =
            await KaryawanRepository.getKaryawan(limit: 10, offset: 0);
        if (res['statusCode'] == 200 && res['data']['status'] == 1) {
          var jsonObject = res['data']['data'] as List;
          karyawans = jsonObject
              .map<KaryawanModel>((e) => KaryawanModel.createFromJson(e))
              .toList();
          yield KaryawanListLoaded(karyawans: karyawans, hasReachMax: false);
        } else if (res['statusCode'] == 400) {
          yield KaryawanStateError(res['data']);
        } else {
          yield KaryawanStateError(res['message']);
        }
      } else if (state is KaryawanListLoaded) {
        KaryawanListLoaded karyawanListLoaded = state;
        Map<String, dynamic> res = await KaryawanRepository.getKaryawan(
            limit: 10, offset: karyawanListLoaded.karyawans.length);
        if (res['statusCode'] == 200 && res['data']['status'] == 1) {
          var jsonObject = res['data']['data'] as List;
          if (jsonObject.length == 0) {
            yield karyawanListLoaded.copyWith(hasReachMax: true);
          } else {
            karyawans = jsonObject
                .map<KaryawanModel>((e) => KaryawanModel.createFromJson(e))
                .toList();
            yield KaryawanListLoaded(
                karyawans: karyawanListLoaded.karyawans + karyawans,
                hasReachMax: false);
          }
        } else if (res['statusCode'] == 400) {
          yield KaryawanStateError(res['data']['message']);
        } else {
          yield KaryawanStateError(res['message']);
        }
      }
    } else if (event is KaryawanTambahEvent) {
      Map<String, dynamic> res =
          await KaryawanRepository.postKaryawan(event.karyawan.toJson());
      if (res['statusCode'] == 200 && res['data']['status'] == 1) {
        yield KaryawanStateSuccess(res['data']);
        this..add(KaryawanGetListEvent(refresh: true));
      } else if (res['statusCode'] == 400) {
        yield KaryawanStateError(res['data']);
      } else {
        yield KaryawanStateError(res['message']);
      }
    } else if (event is KaryawanDeleteEvent) {
      Map<String, dynamic> res =
          await KaryawanRepository.deleteKaryawan(event.id);
      if (res['statusCode'] == 200 && res['data']['status'] == 1) {
        yield KaryawanStateSuccess(res['data']);
        this..add(KaryawanGetListEvent(refresh: true));
      } else if (res['statusCode'] == 400) {
        yield KaryawanStateError(res['data']);
      } else {
        yield KaryawanStateError(res['message']);
      }
    }
  }
}
