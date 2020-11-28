import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wholesale/models/jenis_barang_model.dart';
import 'package:wholesale/models/ukuran_barang_model.dart';
import 'package:wholesale/repositories/distributor/jenis_barang_repository.dart';
import 'package:wholesale/repositories/distributor/ukuran_barang_repository.dart';

part 'ukuran_barang_event.dart';
part 'ukuran_barang_state.dart';

class UkuranBarangBloc extends Bloc<UkuranBarangEvent, UkuranBarangState> {
  UkuranBarangBloc() : super(UkuranBarangInitial());

  @override
  Stream<UkuranBarangState> mapEventToState(
    UkuranBarangEvent event,
  ) async* {
    if (event is UkuranBarangGetListEvent) {
      int limit = 10;
      List<UkuranBarangModel> ukuranBarangs = [];
      if (state is UkuranBarangInitial || event.refresh) {
        Map<String, dynamic> res = await UkuranBarangRepository.getListUkuran(
            limit: limit, offset: 0, search: event.search);
        if (res['statusCode'] == 200 && res['data']['status'] == 1) {
          var jsonObject = res['data']['data'] as List;
          ukuranBarangs = jsonObject
              .map<UkuranBarangModel>(
                  (e) => UkuranBarangModel.createFromJson(e))
              .toList();
          yield UkuranBarangListLoaded(
              ukuranBarangs: ukuranBarangs, hasReachMax: false);
        } else if (res['statusCode'] == 400) {
          yield UkuranBarangStateError(res['data']);
        } else {
          yield UkuranBarangStateError(res);
        }
      } else if (state is UkuranBarangListLoaded) {
        UkuranBarangListLoaded ukuranBarangListLoaded = state;
        if (event.search.isNotEmpty) {
          ukuranBarangListLoaded.ukuranBarangs.clear();
        }
        Map<String, dynamic> res = await UkuranBarangRepository.getListUkuran(
            limit: limit,
            offset: ukuranBarangListLoaded.ukuranBarangs.length,
            search: event.search);
        if (res['statusCode'] == 200 && res['data']['status'] == 1) {
          var jsonObject = res['data']['data'] as List;
          if (jsonObject.length == 0) {
            yield ukuranBarangListLoaded.copyWith(hasReachMax: true);
          } else {
            ukuranBarangs = jsonObject
                .map<UkuranBarangModel>(
                    (e) => UkuranBarangModel.createFromJson(e))
                .toList();
            yield UkuranBarangListLoaded(
                ukuranBarangs:
                    ukuranBarangListLoaded.ukuranBarangs + ukuranBarangs,
                hasReachMax: false);
          }
        } else if (res['statusCode'] == 400) {
          yield UkuranBarangStateError(res['data']);
        } else {
          yield UkuranBarangStateError(res);
        }
      }
    } else if (event is UkuranBarangTambahEvent) {
      Map<String, dynamic> res =
          await UkuranBarangRepository.postUkuran(event.ukuranBarang.toJson());
      if (res['statusCode'] == 200 && res['data']['status'] == 1) {
        yield UkuranBarangStateSuccess(res['data']);
        this..add(UkuranBarangGetListEvent(refresh: true));
      } else if (res['statusCode'] == 400) {
        yield UkuranBarangStateError(res['data']);
      } else {
        yield UkuranBarangStateError(res);
      }
    } else if (event is UkuranBarangEditEvent) {
      Map<String, dynamic> res = await UkuranBarangRepository.putUkuran(
          event.ukuranBarang.id, event.ukuranBarang.toJson());
      if (res['statusCode'] == 200 && res['data']['status'] == 1) {
        yield UkuranBarangStateSuccess(res['data']);
        this..add(UkuranBarangGetListEvent(refresh: true));
      } else if (res['statusCode'] == 400) {
        yield UkuranBarangStateError(res['data']);
      } else {
        yield UkuranBarangStateError(res);
      }
    } else if (event is UkuranBarangDeleteEvent) {
      Map<String, dynamic> res =
          await UkuranBarangRepository.deleteJenis(event.id);
      if (res['statusCode'] == 200 && res['data']['status'] == 1) {
        yield UkuranBarangStateSuccess(res['data']);
        this..add(UkuranBarangGetListEvent(refresh: true));
      } else if (res['statusCode'] == 400) {
        yield UkuranBarangStateError(res['data']);
        this..add(UkuranBarangGetListEvent(refresh: true));
      } else {
        yield UkuranBarangStateError(res);
        this..add(UkuranBarangGetListEvent(refresh: true));
      }
    } else if (event is UkuranBarangGetEvent) {
      yield UkuranBarangStateLoading();
      Map<String, dynamic> res =
          await UkuranBarangRepository.getUkuran(event.id);
      if (res['statusCode'] == 200 && res['data']['status'] == 1) {
        yield UkuranBarangStateSuccess(res['data']);
      } else if (res['statusCode'] == 400) {
        yield UkuranBarangStateError(res['data']);
      } else {
        yield UkuranBarangStateError(res);
      }
    }
  }
}
