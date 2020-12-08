import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:wholesale/bloc/toko/penjualan/tokopenjualan_bloc.dart';
import 'package:wholesale/utils/convert_utils.dart';

class DataPenjualanTokoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TokoPenjualanBloc()..add(TokoPenjualanGetEvent()),
      child: DataPenjualanTokoView(),
    );
  }
}

class DataPenjualanTokoView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TokoPenjualanBloc, TokoPenjualanState>(
      listener: (context, state) {
        if (state is TokoPenjualanStateError) {
          Flushbar(
            title: "Error",
            message: state.errors['message'] ?? "",
            duration: Duration(seconds: 5),
            icon: Icon(
              Icons.do_not_disturb,
              color: Colors.redAccent,
            ),
            flushbarPosition: FlushbarPosition.TOP,
          )..show(Get.context);
        }
      },
      builder: (context, state) {
        if (state is TokoPenjualanStateLoading) {
          return Container(
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (state is TokoPenjualanStateSuccess) {
          Map<String, dynamic> data = state.data;
          return ListView(
            children: [
              ListTile(
                title: Text("Modal"),
                subtitle: Text("Rp${ConvertUtils.formatMoney(data['modal'])}"),
                tileColor: Colors.white,
              ),
              ListTile(
                title: Text("Penjualan"),
                subtitle:
                    Text("Rp${ConvertUtils.formatMoney(data['penjualan'])}"),
                tileColor: Colors.white,
              ),
              ListTile(
                title: Text("Laba"),
                subtitle: Text("Rp${ConvertUtils.formatMoney(data['laba'])}"),
                tileColor: Colors.white,
              ),
            ],
          );
        }
        return Container();
      },
    );
  }
}
