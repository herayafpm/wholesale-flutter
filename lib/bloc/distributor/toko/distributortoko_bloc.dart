import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wholesale/models/distributor_barang_model.dart';
import 'package:wholesale/models/toko_model.dart';
import 'package:wholesale/repositories/distributor/distributor_toko_repository.dart';

part 'distributortoko_event.dart';
part 'distributortoko_state.dart';

class DistributorTokoBloc
    extends Bloc<DistributorTokoEvent, DistributorTokoState> {
  DistributorTokoBloc() : super(DistributorTokoInitial());

  @override
  Stream<DistributorTokoState> mapEventToState(
    DistributorTokoEvent event,
  ) async* {
    if (event is DistributorTokoGetListEvent) {
      List<TokoModel> tokos = [];
      if (state is DistributorTokoInitial || event.refresh) {
        Map<String, dynamic> res = await DistributorTokoRepository.getToko(
            limit: 10, offset: 0, search: event.search);
        if (res['statusCode'] == 200 && res['data']['status'] == 1) {
          var jsonObject = res['data']['data'] as List;
          tokos = jsonObject
              .map<TokoModel>((e) => TokoModel.createFromJson(e))
              .toList();
          yield DistributorTokoListLoaded(tokos: tokos, hasReachMax: false);
        } else if (res['statusCode'] == 400) {
          yield DistributorTokoStateError(res['data']);
        } else {
          yield DistributorTokoStateError(res);
        }
      } else if (state is DistributorTokoListLoaded) {
        DistributorTokoListLoaded distributorTokoListLoaded = state;
        Map<String, dynamic> res = await DistributorTokoRepository.getToko(
            limit: 10,
            offset: distributorTokoListLoaded.tokos.length,
            search: event.search);
        if (res['statusCode'] == 200 && res['data']['status'] == 1) {
          var jsonObject = res['data']['data'] as List;
          if (jsonObject.length == 0) {
            yield distributorTokoListLoaded.copyWith(hasReachMax: true);
          } else {
            tokos = jsonObject
                .map<TokoModel>((e) => TokoModel.createFromJson(e))
                .toList();
            yield DistributorTokoListLoaded(
                tokos: distributorTokoListLoaded.tokos + tokos,
                hasReachMax: false);
          }
        } else if (res['statusCode'] == 400) {
          yield DistributorTokoStateError(res['data']);
        } else {
          yield DistributorTokoStateError(res);
        }
      }
    } else if (event is DistributorTokoTambahEvent) {
      Map<String, dynamic> res =
          await DistributorTokoRepository.postToko(event.toko.toJson());
      if (res['statusCode'] == 200 && res['data']['status'] == 1) {
        yield DistributorTokoStateSuccess(res['data']);
        this..add(DistributorTokoGetListEvent(refresh: true));
      } else if (res['statusCode'] == 400) {
        yield DistributorTokoStateError(res['data']);
      } else {
        yield DistributorTokoStateError(res);
      }
    } else if (event is DistributorTokoDeleteEvent) {
      Map<String, dynamic> res =
          await DistributorTokoRepository.deleteToko(event.id);
      print("data $res");
      if (res['statusCode'] == 200 && res['data']['status'] == 1) {
        yield DistributorTokoStateSuccess(res['data']);
        this..add(DistributorTokoGetListEvent(refresh: true));
      } else if (res['statusCode'] == 400) {
        yield DistributorTokoStateError(res['data']);
        this..add(DistributorTokoGetListEvent(refresh: true));
      } else {
        yield DistributorTokoStateError(res);
        this..add(DistributorTokoGetListEvent(refresh: true));
      }
    } else if (event is DistributorTokoGetListBarangEvent) {
      List<DistributorBarangModel> barangs = [];
      if (state is DistributorTokoInitial || event.refresh) {
        Map<String, dynamic> res =
            await DistributorTokoRepository.getListBarangToko(
                limit: 10,
                offset: 0,
                search: event.search,
                toko_id: event.toko_id);
        if (res['statusCode'] == 200 && res['data']['status'] == 1) {
          var jsonObject = res['data']['data'] as List;
          barangs = jsonObject
              .map<DistributorBarangModel>((e) => DistributorBarangModel(
                  id: int.parse(e['barang_distributor_id']),
                  nama_barang: e['nama_barang'],
                  stok: int.parse(e['stok']),
                  harga_jual: int.parse(e['harga_jual']),
                  keterangan: e['keterangan'],
                  created_at: e['created_at']))
              .toList();
          yield DistributorBarangTokoListLoaded(
              barangs: barangs, hasReachMax: false);
        } else if (res['statusCode'] == 400) {
          yield DistributorTokoStateError(res['data']);
        } else {
          yield DistributorTokoStateError(res);
        }
      } else if (state is DistributorBarangTokoListLoaded) {
        DistributorBarangTokoListLoaded distributorBarangTokoListLoaded = state;
        Map<String, dynamic> res =
            await DistributorTokoRepository.getListBarangToko(
                limit: 10,
                offset: distributorBarangTokoListLoaded.barangs.length,
                search: event.search);
        if (res['statusCode'] == 200 && res['data']['status'] == 1) {
          var jsonObject = res['data']['data'] as List;
          if (jsonObject.length == 0) {
            yield distributorBarangTokoListLoaded.copyWith(hasReachMax: true);
          } else {
            barangs = jsonObject
                .map<DistributorBarangModel>((e) => DistributorBarangModel(
                    id: int.parse(e['barang_distributor_id']),
                    nama_barang: e['nama_barang'],
                    stok: int.parse(e['stok']),
                    harga_jual: int.parse(e['harga_jual']),
                    keterangan: e['keterangan'],
                    created_at: e['created_at']))
                .toList();
            yield DistributorBarangTokoListLoaded(
                barangs: distributorBarangTokoListLoaded.barangs + barangs,
                hasReachMax: false);
          }
        } else if (res['statusCode'] == 400) {
          yield DistributorTokoStateError(res['data']);
        } else {
          yield DistributorTokoStateError(res);
        }
      }
    }
  }
}
