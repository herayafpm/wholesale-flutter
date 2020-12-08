import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wholesale/bloc/toko/transaksi/tokotransaksi_bloc.dart';
import 'package:wholesale/controllers/home_controller.dart';
import 'package:wholesale/models/toko_transaksi_model.dart';
import 'package:wholesale/static_data.dart';
import 'package:wholesale/ui/home_page.dart';
import 'package:wholesale/utils/convert_utils.dart';
import 'package:wholesale/utils/date_time_utils.dart';
import 'package:wholesale/utils/role_utils.dart';

class ListTransaksiTokoPage extends StatelessWidget {
  final homeController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(StaticData.screenWidth, StaticData.screenHeight),
        allowFontScaling: true);
    return Stack(
      children: [
        BlocProvider(
          create: (context) =>
              TokoTransaksiBloc()..add(TokoTransaksiGetListEvent()),
          child: ListTransaksiTokoView(),
        ),
        (RoleUtils.isKaryawan(homeController.role.value))
            ? Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      Get.toNamed("transaksitoko");
                    }),
              )
            : Container()
      ],
    );
  }
}

class ListTransaksiTokoView extends StatelessWidget {
  final homeController = Get.find<HomeController>();
  TokoTransaksiBloc bloc;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    bloc..add(TokoTransaksiGetListEvent(refresh: true));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    bloc..add(TokoTransaksiGetListEvent());
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<TokoTransaksiBloc>(context);
    return BlocConsumer<TokoTransaksiBloc, TokoTransaksiState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is TokoTransaksiListLoaded) {
          TokoTransaksiListLoaded stateData = state;
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
                      TokoTransaksiModel transaksi =
                          stateData.transaksis[index];
                      return Container(
                          margin: EdgeInsets.all(5),
                          child: ListTile(
                              isThreeLine: true,
                              trailing: PopupMenuButton<String>(
                                onSelected: (choice) {
                                  if (choice == "Barang") {
                                    Get.toNamed("barangtransaksitoko",
                                        arguments: transaksi);
                                  }
                                },
                                itemBuilder: (BuildContext context) {
                                  List<String> list = [
                                    "Barang",
                                  ];

                                  return list.map((String choice) {
                                    return PopupMenuItem<String>(
                                      value: choice,
                                      child: Text(choice + " Transaksi"),
                                    );
                                  }).toList();
                                },
                              ),
                              tileColor: Colors.white,
                              subtitle: RichText(
                                text: TextSpan(children: [
                                  (RoleUtils.isPemilikToko(
                                          homeController.role.value))
                                      ? TextSpan(
                                          text:
                                              "Karyawan: ${transaksi.karyawan.nama}\n",
                                          style:
                                              TextStyle(color: Colors.black54))
                                      : TextSpan(),
                                  TextSpan(
                                      text:
                                          "Total Pesanan: ${ConvertUtils.formatMoney(transaksi.jumlah)}\n",
                                      style: TextStyle(color: Colors.black54)),
                                  TextSpan(
                                      text:
                                          "Total Bayar: Rp${ConvertUtils.formatMoney(transaksi.jumlah_bayar)}\n",
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
                "Anda belum menambahkan transaksi",
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
            child: Text("Anda belum menambahkan transaksi"),
          ),
        );
      },
    );
  }
}
