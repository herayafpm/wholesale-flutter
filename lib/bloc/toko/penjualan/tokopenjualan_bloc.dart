import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wholesale/repositories/toko/toko_penjualan_repository.dart';

part 'tokopenjualan_event.dart';
part 'tokopenjualan_state.dart';

class TokoPenjualanBloc extends Bloc<TokoPenjualanEvent, TokoPenjualanState> {
  TokoPenjualanBloc() : super(TokoPenjualanInitial());

  @override
  Stream<TokoPenjualanState> mapEventToState(
    TokoPenjualanEvent event,
  ) async* {
    if (event is TokoPenjualanGetEvent) {
      yield TokoPenjualanStateLoading();
      Map<String, dynamic> res = await TokoPenjualanRepository.getPenjualan();
      if (res['statusCode'] == 200 && res['data']['status'] == 1) {
        yield TokoPenjualanStateSuccess(res['data']['data']);
      } else if (res['statusCode'] == 400) {
        yield TokoPenjualanStateError(res['data']);
      } else {
        yield TokoPenjualanStateError(res);
      }
    }
  }
}
