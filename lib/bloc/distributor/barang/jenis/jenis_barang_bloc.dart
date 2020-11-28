import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wholesale/models/jenis_barang_model.dart';
import 'package:wholesale/repositories/distributor/jenis_barang_repository.dart';

part 'jenis_barang_event.dart';
part 'jenis_barang_state.dart';

class JenisBarangBloc extends Bloc<JenisBarangEvent, JenisBarangState> {
  JenisBarangBloc() : super(JenisBarangInitial());

  @override
  Stream<JenisBarangState> mapEventToState(
    JenisBarangEvent event,
  ) async* {
    if (event is JenisBarangGetListEvent) {
      int limit = 10;
      List<JenisBarangModel> jenisBarangs = [];
      if (state is JenisBarangInitial || event.refresh) {
        Map<String, dynamic> res = await JenisBarangRepository.getListJenis(
            limit: limit, offset: 0, search: event.search);
        if (res['statusCode'] == 200 && res['data']['status'] == 1) {
          var jsonObject = res['data']['data'] as List;
          jenisBarangs = jsonObject
              .map<JenisBarangModel>((e) => JenisBarangModel.createFromJson(e))
              .toList();
          yield JenisBarangListLoaded(
              jenisBarangs: jenisBarangs, hasReachMax: false);
        } else if (res['statusCode'] == 400) {
          yield JenisBarangStateError(res['data']);
        } else {
          yield JenisBarangStateError(res);
        }
      } else if (state is JenisBarangListLoaded) {
        JenisBarangListLoaded jenisBarangListLoaded = state;
        if (event.search.isNotEmpty) {
          jenisBarangListLoaded.jenisBarangs.clear();
        }
        Map<String, dynamic> res = await JenisBarangRepository.getListJenis(
            limit: limit,
            offset: jenisBarangListLoaded.jenisBarangs.length,
            search: event.search);
        if (res['statusCode'] == 200 && res['data']['status'] == 1) {
          var jsonObject = res['data']['data'] as List;
          if (jsonObject.length == 0) {
            yield jenisBarangListLoaded.copyWith(hasReachMax: true);
          } else {
            jenisBarangs = jsonObject
                .map<JenisBarangModel>(
                    (e) => JenisBarangModel.createFromJson(e))
                .toList();
            yield JenisBarangListLoaded(
                jenisBarangs: jenisBarangListLoaded.jenisBarangs + jenisBarangs,
                hasReachMax: false);
          }
        } else if (res['statusCode'] == 400) {
          yield JenisBarangStateError(res['data']);
        } else {
          yield JenisBarangStateError(res);
        }
      }
    } else if (event is JenisBarangTambahEvent) {
      Map<String, dynamic> res =
          await JenisBarangRepository.postJenis(event.jenisBarang.toJson());
      if (res['statusCode'] == 200 && res['data']['status'] == 1) {
        yield JenisBarangStateSuccess(res['data']);
        this..add(JenisBarangGetListEvent(refresh: true));
      } else if (res['statusCode'] == 400) {
        yield JenisBarangStateError(res['data']);
      } else {
        yield JenisBarangStateError(res);
      }
    } else if (event is JenisBarangEditEvent) {
      Map<String, dynamic> res = await JenisBarangRepository.putJenis(
          event.jenisBarang.id, event.jenisBarang.toJson());
      if (res['statusCode'] == 200 && res['data']['status'] == 1) {
        yield JenisBarangStateSuccess(res['data']);
        this..add(JenisBarangGetListEvent(refresh: true));
      } else if (res['statusCode'] == 400) {
        yield JenisBarangStateError(res['data']);
      } else {
        yield JenisBarangStateError(res);
      }
    } else if (event is JenisBarangDeleteEvent) {
      Map<String, dynamic> res =
          await JenisBarangRepository.deleteJenis(event.id);
      if (res['statusCode'] == 200 && res['data']['status'] == 1) {
        yield JenisBarangStateSuccess(res['data']);
        this..add(JenisBarangGetListEvent(refresh: true));
      } else if (res['statusCode'] == 400) {
        yield JenisBarangStateError(res['data']);
        this..add(JenisBarangGetListEvent(refresh: true));
      } else {
        yield JenisBarangStateError(res);
        this..add(JenisBarangGetListEvent(refresh: true));
      }
    } else if (event is JenisBarangGetEvent) {
      yield JenisBarangStateLoading();
      Map<String, dynamic> res = await JenisBarangRepository.getJenis(event.id);
      if (res['statusCode'] == 200 && res['data']['status'] == 1) {
        yield JenisBarangStateSuccess(res['data']);
      } else if (res['statusCode'] == 400) {
        yield JenisBarangStateError(res['data']);
      } else {
        yield JenisBarangStateError(res);
      }
    }
  }
}
