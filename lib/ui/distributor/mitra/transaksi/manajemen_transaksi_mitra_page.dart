import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wholesale/bloc/distributor/transaksi/distributortransaksi_bloc.dart';
import 'package:wholesale/models/distributor_transaksi_model.dart';
import 'package:wholesale/models/toko_model.dart';
import 'package:wholesale/static_data.dart';
import 'package:wholesale/utils/convert_utils.dart';
import 'package:wholesale/utils/date_time_utils.dart';

class ManajemenTransaksiMitraController extends GetxController {
  final toko = TokoModel().obs;
  @override
  void onInit() {
    toko.value = Get.arguments;
    super.onInit();
  }
}

class ManajemenTransaksiMitraPage extends StatelessWidget {
  final controller = Get.put(ManajemenTransaksiMitraController());
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(StaticData.screenWidth, StaticData.screenHeight),
        allowFontScaling: true);
    return Scaffold(
      appBar: AppBar(
        title: Text("Manajemen Transaksi ${controller.toko.value.nama}"),
      ),
      body: BlocProvider(
        create: (context) => DistributorTransaksiBloc()
          ..add(DistributorTransaksiGetListEvent(
              toko_id: controller.toko.value.id)),
        child: ManajemenTransaksiMitraView(),
      ),
    );
  }
}

class ManajemenTransaksiMitraView extends StatelessWidget {
  final controller = Get.find<ManajemenTransaksiMitraController>();
  DistributorTransaksiBloc bloc;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    bloc
      ..add(DistributorTransaksiGetListEvent(
          refresh: true, toko_id: controller.toko.value.id));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    bloc
      ..add(
          DistributorTransaksiGetListEvent(toko_id: controller.toko.value.id));
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<DistributorTransaksiBloc>(context);
    return BlocConsumer<DistributorTransaksiBloc, DistributorTransaksiState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is DistributorTransaksiListLoaded) {
          DistributorTransaksiListLoaded stateData = state;
          if (stateData.transaksis != null && stateData.transaksis.length > 0) {
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
                    itemCount: stateData.transaksis.length,
                    itemBuilder: (BuildContext context, int index) {
                      DistributorTransaksiModel transaksi =
                          stateData.transaksis[index];
                      return Container(
                          margin: EdgeInsets.all(5),
                          child: ListTile(
                              trailing: PopupMenuButton<String>(
                                onSelected: (choice) {
                                  if (choice == "Detail") {
                                    Get.toNamed("detailtransaksimitra",
                                        arguments: transaksi);
                                  } else if (choice == "Barang") {
                                    Get.toNamed("barangtransaksimitra",
                                        arguments: transaksi);
                                  } else if (choice == "List Pelunasan") {
                                    Get.toNamed("listpelunasantransaksimitra",
                                        arguments: transaksi);
                                  } else if (choice == "Pelunasan") {
                                    Get.toNamed("pelunasantransaksimitra",
                                        arguments: transaksi);
                                  }
                                },
                                itemBuilder: (BuildContext context) {
                                  List<String> list = [
                                    "Detail",
                                    "Barang",
                                    "List Pelunasan"
                                  ];
                                  if (transaksi.status == false) {
                                    list.add("Pelunasan");
                                  }

                                  return list.map((String choice) {
                                    return PopupMenuItem<String>(
                                      value: choice,
                                      child: Text(choice + " Transaksi"),
                                    );
                                  }).toList();
                                },
                              ),
                              tileColor: Colors.white,
                              isThreeLine: true,
                              leading: (transaksi.status)
                                  ? Icon(Icons.check, color: Colors.greenAccent)
                                  : Icon(Icons.clear, color: Colors.redAccent),
                              subtitle: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                      text:
                                          "Total Pesanan: ${ConvertUtils.formatMoney(transaksi.jumlah)}\n",
                                      style: TextStyle(color: Colors.black54)),
                                  TextSpan(
                                      text:
                                          "Total Bayar: Rp${ConvertUtils.formatMoney(transaksi.jumlah_bayar)}\n",
                                      style: TextStyle(color: Colors.black54)),
                                  TextSpan(
                                      text:
                                          "Total Sudah Dibayar: Rp${ConvertUtils.formatMoney(transaksi.bayar)}",
                                      style: TextStyle(color: Colors.black54)),
                                ]),
                              ),
                              title: Text(
                                  "${DateTimeUtils.humanize(transaksi.created_at)}")));
                    }));
          } else {
            return Container(
              child: Center(
                  child: Txt(
                "Toko ini belum memiliki transaksi",
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
            child: Text("Toko ini belum memiliki transaksi"),
          ),
        );
      },
    );
  }
}
