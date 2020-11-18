import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wholesale/models/toko_model.dart';
import 'package:wholesale/repositories/toko/toko_repository.dart';

part 'toko_event.dart';
part 'toko_state.dart';

class TokoBloc extends Bloc<TokoEvent, TokoState> {
  TokoBloc() : super(TokoInitial());

  @override
  Stream<TokoState> mapEventToState(
    TokoEvent event,
  ) async* {
    if (event is TokoGetEvent) {
      yield TokoStateLoading();
      Map<String, dynamic> res = await TokoRepository.getToko();
      if (res['statusCode'] == 400 || res['data']['status'] == false) {
        yield TokoStateError(res['data']);
      } else if (res['statusCode'] == 200) {
        yield TokoStateSuccess(res['data']);
      } else {
        yield TokoStateError(res['data']);
      }
    } else if (event is TokoUpdateEvent) {
      Map<String, dynamic> res =
          await TokoRepository.updateToko(event.toko.toJson());
      if (res['statusCode'] == 400 || res['data']['status'] == false) {
        yield TokoStateError(res['data']);
      } else if (res['statusCode'] == 200) {
        yield TokoFormSuccess(res['data']);
      } else {
        yield TokoStateError(res['data']);
      }
    }
  }
}
