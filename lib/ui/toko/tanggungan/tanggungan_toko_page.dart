import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wholesale/bloc/toko/tanggungan/tokotanggungan_bloc.dart';
import 'package:wholesale/models/distributor_transaksi_model.dart';
import 'package:wholesale/models/toko_model.dart';
import 'package:wholesale/static_data.dart';
import 'package:wholesale/utils/convert_utils.dart';
import 'package:wholesale/utils/date_time_utils.dart';

class TanggunganTokoController extends GetxController {
  final toko = TokoModel().obs;
  @override
  void onInit() {
    toko.value = Get.arguments;
    super.onInit();
  }
}

class TanggunganTokoPage extends StatelessWidget {
  final controller = Get.put(TanggunganTokoController());
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(StaticData.screenWidth, StaticData.screenHeight),
        allowFontScaling: true);
    return BlocProvider(
      create: (context) =>
          TokoTanggunganBloc()..add(TokoTanggunganGetListEvent()),
      child: TanggunganTokoView(),
    );
  }
}

class TanggunganTokoView extends StatelessWidget {
  final controller = Get.find<TanggunganTokoController>();
  TokoTanggunganBloc bloc;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    bloc
      ..add(TokoTanggunganGetListEvent(
        refresh: true,
      ));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    bloc..add(TokoTanggunganGetListEvent());
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<TokoTanggunganBloc>(context);
    return BlocConsumer<TokoTanggunganBloc, TokoTanggunganState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is TokoTanggunganListLoaded) {
          TokoTanggunganListLoaded stateData = state;
          if (stateData.tanggungans != null &&
              stateData.tanggungans.length > 0) {
            return SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                enablePullUp: true,
                header: WaterDropMaterialHeader(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                child: ListView.builder(
                    itemCount: stateData.tanggungans.length,
                    itemBuilder: (BuildContext context, int index) {
                      DistributorTransaksiModel tanggungan =
                          stateData.tanggungans[index];
                      return Container(
                          margin: EdgeInsets.all(5),
                          child: ListTile(
                              trailing: PopupMenuButton<String>(
                                onSelected: (choice) {
                                  if (choice == "Detail") {
                                    Get.toNamed("detailtanggungantoko",
                                        arguments: tanggungan);
                                  } else if (choice == "Barang") {
                                    Get.toNamed("barangtanggungantoko",
                                        arguments: tanggungan);
                                  } else if (choice == "List Pelunasan") {
                                    Get.toNamed("listpelunasantanggungantoko",
                                        arguments: tanggungan);
                                  } else if (choice == "Pelunasan") {
                                    Get.toNamed("pelunasantanggungantoko",
                                        arguments: tanggungan);
                                  }
                                },
                                itemBuilder: (BuildContext context) {
                                  List<String> list = [
                                    "Detail",
                                    "Barang",
                                    "List Pelunasan"
                                  ];
                                  return list.map((String choice) {
                                    return PopupMenuItem<String>(
                                      value: choice,
                                      child: Text(choice + " Tanggungan"),
                                    );
                                  }).toList();
                                },
                              ),
                              tileColor: Colors.white,
                              leading: (tanggungan.status)
                                  ? Icon(Icons.check, color: Colors.greenAccent)
                                  : Icon(Icons.clear, color: Colors.redAccent),
                              subtitle: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                      text:
                                          "Total Pesanan: ${ConvertUtils.formatMoney(tanggungan.jumlah)}\n",
                                      style: TextStyle(color: Colors.black54)),
                                  TextSpan(
                                      text:
                                          "Total Bayar: Rp${ConvertUtils.formatMoney(tanggungan.jumlah_bayar)}",
                                      style: TextStyle(color: Colors.black54)),
                                ]),
                              ),
                              title: Text(
                                  "${DateTimeUtils.humanize(tanggungan.created_at)}")));
                    }));
          } else {
            return Container(
              child: Center(
                  child: Txt(
                "Anda belum memiliki tanggungan",
                style: TxtStyle()
                  ..fontSize(24.ssp)
                  ..textColor(Colors.white)
                  ..textAlign.center(),
              )),
            );
          }
        }
        return Container(
          child: Center(
            child: Text("Anda belum memiliki tanggungan"),
          ),
        );
      },
    );
  }
}
