import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wholesale/repositories/toko/toko_dashboard_repository.dart';

part 'tokodashboard_event.dart';
part 'tokodashboard_state.dart';

class TokoDashboardBloc extends Bloc<TokoDashboardEvent, TokoDashboardState> {
  TokoDashboardBloc() : super(TokoDashboardInitial());

  @override
  Stream<TokoDashboardState> mapEventToState(
    TokoDashboardEvent event,
  ) async* {
    if (event is TokoDashboardGetEvent) {
      yield TokoDashboardStateLoading();
      Map<String, dynamic> res = await TokoDashboardRepository.getData();
      if (res['statusCode'] == 200 && res['data']['status'] == 1) {
        yield TokoDashboardStateSuccess(res['data']['data']);
      } else if (res['statusCode'] == 400) {
        yield TokoDashboardStateError(res['data']);
      } else {
        yield TokoDashboardStateError(res);
      }
    }
  }
}
