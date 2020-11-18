import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wholesale/models/distributor_barang_model.dart';
import 'package:wholesale/repositories/distributor/distributor_barang_repository.dart';

part 'distributor_barang_event.dart';
part 'distributor_barang_state.dart';

class DistributorBarangBloc
    extends Bloc<DistributorBarangEvent, DistributorBarangState> {
  DistributorBarangBloc() : super(DistributorBarangInitial());

  @override
  Stream<DistributorBarangState> mapEventToState(
    DistributorBarangEvent event,
  ) async* {
    if (event is DistributorBarangGetListEvent) {
      int limit = 10;
      List<DistributorBarangModel> distributorBarangs = [];
      if (state is DistributorBarangInitial || event.refresh) {
        Map<String, dynamic> res = await DistributorBarangRepository.getBarangs(
            limit: limit, offset: 0, search: event.search);
        if (res['statusCode'] == 200 && res['data']['status'] == 1) {
          var jsonObject = res['data']['data'] as List;
          distributorBarangs = jsonObject
              .map<DistributorBarangModel>(
                  (e) => DistributorBarangModel.createFromJson(e))
              .toList();
          yield DistributorBarangListLoaded(
              distributorBarangs: distributorBarangs, hasReachMax: false);
        } else if (res['statusCode'] == 400) {
          yield DistributorBarangStateError(res['data']);
        } else {
          yield DistributorBarangStateError(res);
        }
      } else if (state is DistributorBarangListLoaded) {
        DistributorBarangListLoaded distributorBarangListLoaded = state;
        if (event.search.isNotEmpty) {
          distributorBarangListLoaded.distributorBarangs.clear();
        }
        Map<String, dynamic> res = await DistributorBarangRepository.getBarangs(
            limit: limit,
            offset: distributorBarangListLoaded.distributorBarangs.length,
            search: event.search);
        if (res['statusCode'] == 200 && res['data']['status'] == 1) {
          var jsonObject = res['data']['data'] as List;
          if (jsonObject.length == 0) {
            yield distributorBarangListLoaded.copyWith(hasReachMax: true);
          } else {
            distributorBarangs = jsonObject
                .map<DistributorBarangModel>(
                    (e) => DistributorBarangModel.createFromJson(e))
                .toList();
            yield DistributorBarangListLoaded(
                distributorBarangs:
                    distributorBarangListLoaded.distributorBarangs +
                        distributorBarangs,
                hasReachMax: false);
          }
        } else if (res['statusCode'] == 400) {
          yield DistributorBarangStateError(res['data']);
        } else {
          yield DistributorBarangStateError(res);
        }
      }
    } else if (event is DistributorBarangTambahEvent) {
      Map<String, dynamic> res = await DistributorBarangRepository.postBarang(
          event.distributorBarang.toJson());
      if (res['statusCode'] == 200 && res['data']['status'] == 1) {
        yield DistributorBarangFormSuccess(res['data']);
        this..add(DistributorBarangGetListEvent(refresh: true));
      } else if (res['statusCode'] == 400) {
        yield DistributorBarangStateError(res['data']);
      } else {
        yield DistributorBarangStateError(res);
      }
    } else if (event is DistributorBarangEditEvent) {
      Map<String, dynamic> res = await DistributorBarangRepository.putBarang(
          event.distributorBarang.id, event.distributorBarang.toJson());
      if (res['statusCode'] == 200 && res['data']['status'] == 1) {
        yield DistributorBarangFormSuccess(res['data']);
        this..add(DistributorBarangGetEvent(event.distributorBarang.id));
      } else if (res['statusCode'] == 400) {
        yield DistributorBarangStateError(res['data']);
      } else {
        yield DistributorBarangStateError(res);
      }
    } else if (event is DistributorBarangDeleteEvent) {
      Map<String, dynamic> res =
          await DistributorBarangRepository.deleteBarang(event.id);
      if (res['statusCode'] == 200 && res['data']['status'] == 1) {
        yield DistributorBarangFormSuccess(res['data']);
      } else if (res['statusCode'] == 400) {
        yield DistributorBarangStateError(res['data']);
        this..add(DistributorBarangGetEvent(event.id));
      } else {
        yield DistributorBarangStateError(res);
        this..add(DistributorBarangGetEvent(event.id));
      }
    } else if (event is DistributorBarangGetEvent) {
      yield DistributorBarangStateLoading();
      Map<String, dynamic> res =
          await DistributorBarangRepository.getBarang(event.id);
      if (res['statusCode'] == 200 && res['data']['status'] == 1) {
        yield DistributorBarangStateSuccess(res['data']);
      } else if (res['statusCode'] == 400) {
        yield DistributorBarangStateError(res['data']);
      } else {
        yield DistributorBarangStateError(res);
      }
    } else if (event is DistributorBarangGetStaticEvent) {
      yield DistributorBarangStateLoading();
      Map<String, dynamic> res = await DistributorBarangRepository.getStatic();
      if (res['statusCode'] == 200 && res['data']['status'] == 1) {
        yield DistributorBarangStaticStateSuccess(res['data']);
      } else if (res['statusCode'] == 400) {
        yield DistributorBarangStateError(res['data']);
      } else {
        yield DistributorBarangStateError(res);
      }
    }
  }
}
