import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wholesale/models/toko_barang_model.dart';
import 'package:wholesale/repositories/toko/toko_barang_repository.dart';

part 'toko_barang_event.dart';
part 'toko_barang_state.dart';

class TokoBarangBloc extends Bloc<TokoBarangEvent, TokoBarangState> {
  TokoBarangBloc() : super(TokoBarangInitial());

  @override
  Stream<TokoBarangState> mapEventToState(
    TokoBarangEvent event,
  ) async* {
    if (event is TokoBarangGetListEvent) {
      int limit = 10;
      List<TokoBarangModel> tokoBarangs = [];
      if (state is TokoBarangInitial || event.refresh) {
        Map<String, dynamic> res = await TokoBarangRepository.getBarangs(
            limit: limit, offset: 0, search: event.search);
        if (res['statusCode'] == 200 && res['data']['status'] == 1) {
          var jsonObject = res['data']['data'] as List;
          tokoBarangs = jsonObject
              .map<TokoBarangModel>((e) => TokoBarangModel.createFromJson(e))
              .toList();
          yield TokoBarangListLoaded(
              tokoBarangs: tokoBarangs, hasReachMax: false);
        } else if (res['statusCode'] == 400) {
          yield TokoBarangStateError(res['data']);
        } else {
          yield TokoBarangStateError(res);
        }
      } else if (state is TokoBarangListLoaded) {
        TokoBarangListLoaded tokoBarangListLoaded = state;
        if (event.search.isNotEmpty) {
          tokoBarangListLoaded.tokoBarangs.clear();
        }
        Map<String, dynamic> res = await TokoBarangRepository.getBarangs(
            limit: limit,
            offset: tokoBarangListLoaded.tokoBarangs.length,
            search: event.search);
        if (res['statusCode'] == 200 && res['data']['status'] == 1) {
          var jsonObject = res['data']['data'] as List;
          if (jsonObject.length == 0) {
            yield tokoBarangListLoaded.copyWith(hasReachMax: true);
          } else {
            tokoBarangs = jsonObject
                .map<TokoBarangModel>((e) => TokoBarangModel.createFromJson(e))
                .toList();
            yield TokoBarangListLoaded(
                tokoBarangs: tokoBarangListLoaded.tokoBarangs + tokoBarangs,
                hasReachMax: false);
          }
        } else if (res['statusCode'] == 400) {
          yield TokoBarangStateError(res['data']);
        } else {
          yield TokoBarangStateError(res);
        }
      }
    } else if (event is TokoBarangEditEvent) {
      Map<String, dynamic> res = await TokoBarangRepository.putBarang(
          event.tokoBarang.id, event.tokoBarang.toJson());
      if (res['statusCode'] == 200 && res['data']['status'] == 1) {
        yield TokoBarangFormSuccess(res['data']);
        this..add(TokoBarangGetEvent(event.tokoBarang.id));
      } else if (res['statusCode'] == 400) {
        yield TokoBarangStateError(res['data']);
      } else {
        yield TokoBarangStateError(res);
      }
    } else if (event is TokoBarangDeleteEvent) {
      Map<String, dynamic> res =
          await TokoBarangRepository.deleteBarang(event.id);
      if (res['statusCode'] == 200 && res['data']['status'] == 1) {
        yield TokoBarangFormSuccess(res['data']);
      } else if (res['statusCode'] == 400) {
        yield TokoBarangStateError(res['data']);
        this..add(TokoBarangGetEvent(event.id));
      } else {
        yield TokoBarangStateError(res);
        this..add(TokoBarangGetEvent(event.id));
      }
    } else if (event is TokoBarangGetEvent) {
      yield TokoBarangStateLoading();
      Map<String, dynamic> res = await TokoBarangRepository.getBarang(event.id);
      if (res['statusCode'] == 200 && res['data']['status'] == 1) {
        yield TokoBarangStateSuccess(res['data']);
      } else if (res['statusCode'] == 400) {
        yield TokoBarangStateError(res['data']);
      } else {
        yield TokoBarangStateError(res);
      }
    }
  }
}
