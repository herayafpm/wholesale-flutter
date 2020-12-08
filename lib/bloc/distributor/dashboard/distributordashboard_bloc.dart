import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wholesale/repositories/distributor/distributor_dashboard_repository.dart';

part 'distributordashboard_event.dart';
part 'distributordashboard_state.dart';

class DistributorDashboardBloc
    extends Bloc<DistributorDashboardEvent, DistributorDashboardState> {
  DistributorDashboardBloc() : super(DistributorDashboardInitial());

  @override
  Stream<DistributorDashboardState> mapEventToState(
    DistributorDashboardEvent event,
  ) async* {
    if (event is DistributorDashboardGetEvent) {
      yield DistributorDashboardStateLoading();
      Map<String, dynamic> res = await DistributorDashboardRepository.getData();
      if (res['statusCode'] == 200 && res['data']['status'] == 1) {
        yield DistributorDashboardStateSuccess(res['data']['data']);
      } else if (res['statusCode'] == 400) {
        yield DistributorDashboardStateError(res['data']);
      } else {
        yield DistributorDashboardStateError(res);
      }
    }
  }
}
