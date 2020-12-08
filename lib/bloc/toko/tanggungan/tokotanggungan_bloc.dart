import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wholesale/models/distributor_pelunasan_model.dart';
import 'package:wholesale/models/distributor_transaksi_model.dart';
import 'package:wholesale/repositories/toko/toko_tanggungan_repository.dart';

part 'tokotanggungan_event.dart';
part 'tokotanggungan_state.dart';

class TokoTanggunganBloc
    extends Bloc<TokoTanggunganEvent, TokoTanggunganState> {
  TokoTanggunganBloc() : super(TokoTanggunganInitial());

  @override
  Stream<TokoTanggunganState> mapEventToState(
    TokoTanggunganEvent event,
  ) async* {
    if (event is TokoTanggunganGetListEvent) {
      List<DistributorTransaksiModel> tanggungans;
      if (state is TokoTanggunganInitial) {
        Map<String, dynamic> res =
            await TokoTanggunganRepository.getTanggungan(limit: 10, offset: 0);
        if (res['statusCode'] == 200 && res['data']['status'] == 1) {
          var jsonObject = res['data']['data'] as List;
          tanggungans = jsonObject
              .map<DistributorTransaksiModel>(
                  (e) => DistributorTransaksiModel.createFromJson(e))
              .toList();
          yield TokoTanggunganListLoaded(
              tanggungans: tanggungans, hasReachMax: false);
        } else if (res['statusCode'] == 400) {
          yield TokoTanggunganStateError(res['data']);
        } else {
          yield TokoTanggunganStateError(res);
        }
      } else if (state is TokoTanggunganListLoaded) {
        TokoTanggunganListLoaded distributorTokoListLoaded = state;
        Map<String, dynamic> res = await TokoTanggunganRepository.getTanggungan(
            limit: 10, offset: distributorTokoListLoaded.tanggungans.length);
        if (res['statusCode'] == 200 && res['data']['status'] == 1) {
          var jsonObject = res['data']['data'] as List;
          if (jsonObject.length == 0) {
            yield distributorTokoListLoaded.copyWith(hasReachMax: true);
          } else {
            tanggungans = jsonObject
                .map<DistributorTransaksiModel>(
                    (e) => DistributorTransaksiModel.createFromJson(e))
                .toList();
            yield TokoTanggunganListLoaded(
                tanggungans:
                    distributorTokoListLoaded.tanggungans + tanggungans,
                hasReachMax: false);
          }
        } else if (res['statusCode'] == 400) {
          yield TokoTanggunganStateError(res['data']);
        } else {
          yield TokoTanggunganStateError(res);
        }
      }
    }
  }
}
