import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:wholesale/bloc/distributor/penjualan/distributorpenjualan_bloc.dart';
import 'package:wholesale/utils/convert_utils.dart';

class DataPenjualanDistributorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          DistributorPenjualanBloc()..add(DistributorPenjualanGetEvent()),
      child: DataPenjualanDistributorView(),
    );
  }
}

class DataPenjualanDistributorView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DistributorPenjualanBloc, DistributorPenjualanState>(
      listener: (context, state) {
        if (state is DistributorPenjualanStateError) {
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
        if (state is DistributorPenjualanStateLoading) {
          return Container(
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (state is DistributorPenjualanStateSuccess) {
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
