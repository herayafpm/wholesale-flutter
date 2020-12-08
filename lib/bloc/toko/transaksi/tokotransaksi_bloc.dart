import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wholesale/models/toko_transaksi_model.dart';
import 'package:wholesale/repositories/toko/toko_transaksi_repository.dart';

part 'tokotransaksi_event.dart';
part 'tokotransaksi_state.dart';

class TokoTransaksiBloc extends Bloc<TokoTransaksiEvent, TokoTransaksiState> {
  TokoTransaksiBloc() : super(TokoTransaksiInitial());

  @override
  Stream<TokoTransaksiState> mapEventToState(
    TokoTransaksiEvent event,
  ) async* {
    if (event is TokoTransaksiGetListEvent) {
      List<TokoTransaksiModel> transaksis;
      if (state is TokoTransaksiInitial || event.refresh) {
        Map<String, dynamic> res =
            await TokoTransaksiRepository.getTransaksi(limit: 10, offset: 0);
        if (res['statusCode'] == 200 && res['data']['status'] == 1) {
          var jsonObject = res['data']['data'] as List;
          transaksis = jsonObject
              .map<TokoTransaksiModel>(
                  (e) => TokoTransaksiModel.createFromJson(e))
              .toList();
          yield TokoTransaksiListLoaded(
              transaksis: transaksis, hasReachMax: false);
        } else if (res['statusCode'] == 400) {
          yield TokoTransaksiStateError(res['data']);
        } else {
          yield TokoTransaksiStateError(res);
        }
      } else if (state is TokoTransaksiListLoaded) {
        TokoTransaksiListLoaded tokoTokoListLoaded = state;
        Map<String, dynamic> res = await TokoTransaksiRepository.getTransaksi(
            limit: 10, offset: tokoTokoListLoaded.transaksis.length);
        if (res['statusCode'] == 200 && res['data']['status'] == 1) {
          var jsonObject = res['data']['data'] as List;
          if (jsonObject.length == 0) {
            yield tokoTokoListLoaded.copyWith(hasReachMax: true);
          } else {
            transaksis = jsonObject
                .map<TokoTransaksiModel>(
                    (e) => TokoTransaksiModel.createFromJson(e))
                .toList();
            yield TokoTransaksiListLoaded(
                transaksis: tokoTokoListLoaded.transaksis + transaksis,
                hasReachMax: false);
          }
        } else if (res['statusCode'] == 400) {
          yield TokoTransaksiStateError(res['data']);
        } else {
          yield TokoTransaksiStateError(res);
        }
      }
    } else if (event is TokoTransaksiTambahEvent) {
      yield TokoTransaksiStateLoading();
      Map<String, dynamic> res =
          await TokoTransaksiRepository.postTransaksi(event.transaksi.toJson());
      if (res['statusCode'] == 200 && res['data']['status'] == 1) {
        yield TokoTransaksiStateSuccess(res['data']);
      } else if (res['statusCode'] == 400) {
        yield TokoTransaksiStateError(res['data']);
      } else {
        yield TokoTransaksiStateError(res);
      }
    }
  }
}
