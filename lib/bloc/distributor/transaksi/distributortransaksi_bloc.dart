import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wholesale/models/distributor_pelunasan_model.dart';
import 'package:wholesale/models/distributor_transaksi_model.dart';
import 'package:wholesale/repositories/distributor/distributor_transaksi_repository.dart';

part 'distributortransaksi_event.dart';
part 'distributortransaksi_state.dart';

class DistributorTransaksiBloc
    extends Bloc<DistributorTransaksiEvent, DistributorTransaksiState> {
  DistributorTransaksiBloc() : super(DistributorTransaksiInitial());

  @override
  Stream<DistributorTransaksiState> mapEventToState(
    DistributorTransaksiEvent event,
  ) async* {
    if (event is DistributorTransaksiGetListEvent) {
      List<DistributorTransaksiModel> transaksis;
      if (state is DistributorTransaksiInitial || event.refresh) {
        Map<String, dynamic> res =
            await DistributorTransaksiRepository.getTransaksi(
                limit: 10, offset: 0, toko_id: event.toko_id);
        if (res['statusCode'] == 200 && res['data']['status'] == 1) {
          var jsonObject = res['data']['data'] as List;
          transaksis = jsonObject
              .map<DistributorTransaksiModel>(
                  (e) => DistributorTransaksiModel.createFromJson(e))
              .toList();
          yield DistributorTransaksiListLoaded(
              transaksis: transaksis, hasReachMax: false);
        } else if (res['statusCode'] == 400) {
          yield DistributorTransaksiStateError(res['data']);
        } else {
          yield DistributorTransaksiStateError(res);
        }
      } else if (state is DistributorTransaksiListLoaded) {
        DistributorTransaksiListLoaded distributorTokoListLoaded = state;
        Map<String, dynamic> res =
            await DistributorTransaksiRepository.getTransaksi(
                limit: 10,
                offset: distributorTokoListLoaded.transaksis.length,
                toko_id: event.toko_id);
        if (res['statusCode'] == 200 && res['data']['status'] == 1) {
          var jsonObject = res['data']['data'] as List;
          if (jsonObject.length == 0) {
            yield distributorTokoListLoaded.copyWith(hasReachMax: true);
          } else {
            transaksis = jsonObject
                .map<DistributorTransaksiModel>(
                    (e) => DistributorTransaksiModel.createFromJson(e))
                .toList();
            yield DistributorTransaksiListLoaded(
                transaksis: distributorTokoListLoaded.transaksis + transaksis,
                hasReachMax: false);
          }
        } else if (res['statusCode'] == 400) {
          yield DistributorTransaksiStateError(res['data']);
        } else {
          yield DistributorTransaksiStateError(res);
        }
      }
    } else if (event is DistributorTransaksiTambahEvent) {
      yield DistributorTransaksiStateLoading();
      Map<String, dynamic> res =
          await DistributorTransaksiRepository.postTransaksi(
              event.transaksi.toJson());
      if (res['statusCode'] == 200 && res['data']['status'] == 1) {
        yield DistributorTransaksiStateSuccess(res['data']);
      } else if (res['statusCode'] == 400) {
        yield DistributorTransaksiStateError(res['data']);
      } else {
        yield DistributorTransaksiStateError(res);
      }
    } else if (event is DistributorTransaksiPelunasanEvent) {
      yield DistributorTransaksiStateLoading();
      Map<String, dynamic> res =
          await DistributorTransaksiRepository.pelunasanTransaksi(
              event.pelunasan.toJson());
      if (res['statusCode'] == 200 && res['data']['status'] == 1) {
        yield DistributorTransaksiStateSuccess(res['data']);
      } else if (res['statusCode'] == 400) {
        yield DistributorTransaksiStateError(res['data']);
      } else {
        yield DistributorTransaksiStateError(res);
      }
    }
  }
}
