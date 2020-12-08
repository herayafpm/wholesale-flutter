import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wholesale/repositories/distributor/distributor_penjualan_repository.dart';

part 'distributorpenjualan_event.dart';
part 'distributorpenjualan_state.dart';

class DistributorPenjualanBloc
    extends Bloc<DistributorPenjualanEvent, DistributorPenjualanState> {
  DistributorPenjualanBloc() : super(DistributorPenjualanInitial());

  @override
  Stream<DistributorPenjualanState> mapEventToState(
    DistributorPenjualanEvent event,
  ) async* {
    if (event is DistributorPenjualanGetEvent) {
      yield DistributorPenjualanStateLoading();
      Map<String, dynamic> res =
          await DistributorPenjualanRepository.getPenjualan();
      if (res['statusCode'] == 200 && res['data']['status'] == 1) {
        yield DistributorPenjualanStateSuccess(res['data']['data']);
      } else if (res['statusCode'] == 400) {
        yield DistributorPenjualanStateError(res['data']);
      } else {
        yield DistributorPenjualanStateError(res);
      }
    }
  }
}
