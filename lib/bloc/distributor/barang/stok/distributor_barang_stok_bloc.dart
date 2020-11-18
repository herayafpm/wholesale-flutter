import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wholesale/models/distributor_barang_stok_model.dart';
import 'package:wholesale/models/toko_model.dart';
import 'package:wholesale/repositories/distributor/distributor_barang_stok_repository.dart';
import 'package:wholesale/repositories/distributor/distributor_toko_repository.dart';

part 'distributor_barang_stok_event.dart';
part 'distributor_barang_stok_state.dart';

class DistributorBarangStokBloc
    extends Bloc<DistributorBarangStokEvent, DistributorBarangStokState> {
  DistributorBarangStokBloc() : super(DistributorBarangStokInitial());

  @override
  Stream<DistributorBarangStokState> mapEventToState(
    DistributorBarangStokEvent event,
  ) async* {
    if (event is DistributorBarangStokGetListEvent) {
      int limit = 10;
      List<DistributorBarangStokModel> stoks = [];
      if (state is DistributorBarangStokInitial || event.refresh) {
        Map<String, dynamic> res =
            await DistributorBarangStokRepository.getStoks(event.id,
                limit: limit, offset: 0);
        if (res['statusCode'] == 200 && res['data']['status'] == 1) {
          var jsonObject = res['data']['data'] as List;
          stoks = jsonObject
              .map<DistributorBarangStokModel>(
                  (e) => DistributorBarangStokModel.createFromJson(e))
              .toList();
          yield DistributorBarangStokListLoaded(
              stoks: stoks, hasReachMax: false);
        } else if (res['statusCode'] == 400) {
          yield DistributorBarangStokStateError(res['data']);
        } else {
          yield DistributorBarangStokStateError(res);
        }
      } else if (state is DistributorBarangStokListLoaded) {
        DistributorBarangStokListLoaded distributorBarangStokListLoaded = state;
        Map<String, dynamic> res =
            await DistributorBarangStokRepository.getStoks(event.id,
                limit: limit,
                offset: distributorBarangStokListLoaded.stoks.length);
        if (res['statusCode'] == 200 && res['data']['status'] == 1) {
          var jsonObject = res['data']['data'] as List;
          if (jsonObject.length == 0) {
            yield distributorBarangStokListLoaded.copyWith(hasReachMax: true);
          } else {
            stoks = jsonObject
                .map<DistributorBarangStokModel>(
                    (e) => DistributorBarangStokModel.createFromJson(e))
                .toList();
            yield DistributorBarangStokListLoaded(
                stoks: distributorBarangStokListLoaded.stoks + stoks,
                hasReachMax: false);
          }
        } else if (res['statusCode'] == 400) {
          yield DistributorBarangStokStateError(res['data']);
        } else {
          yield DistributorBarangStokStateError(res);
        }
      }
    } else if (event is DistributorBarangStokTambahEvent) {
      Map<String, dynamic> res = await DistributorBarangStokRepository.postStok(
          event.id, event.stoks.toJson());
      if (res['statusCode'] == 200 && res['data']['status'] == 1) {
        yield DistributorBarangStokStateSuccess(res['data']);
        this..add(DistributorBarangStokGetListEvent(event.id, refresh: true));
      } else if (res['statusCode'] == 400) {
        yield DistributorBarangStokStateError(res['data']);
      } else {
        yield DistributorBarangStokStateError(res);
      }
    }
  }
}
