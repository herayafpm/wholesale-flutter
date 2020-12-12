import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wholesale/models/distributor_transaksi_model.dart';
import 'package:wholesale/static_data.dart';
import 'package:wholesale/utils/convert_utils.dart';
import 'package:wholesale/utils/date_time_utils.dart';

// ignore: must_be_immutable
class ListPelunasanTransaksiMitraPage extends StatelessWidget {
  DistributorTransaksiModel transaksi;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(StaticData.screenWidth, StaticData.screenHeight),
        allowFontScaling: true);
    transaksi = Get.arguments;
    return Scaffold(
        appBar: AppBar(
          title: Text("List Pelunasan Transaksi Mitra"),
        ),
        body: ListView(
          children: transaksi.pelunasans
              .map((e) => ListTile(
                  isThreeLine: true,
                  tileColor: Colors.white,
                  title: Text("${DateTimeUtils.humanize(e.created_at)}"),
                  subtitle: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: "Keterangan: ${e.keterangan}\n",
                          style: TextStyle(color: Colors.black54)),
                      TextSpan(
                          text:
                              "Bayaran Sebelumnya: ${ConvertUtils.formatMoney(e.bayar_sebelumnya)}\n",
                          style: TextStyle(color: Colors.black54)),
                      TextSpan(
                          text:
                              "Membayar: ${ConvertUtils.formatMoney(e.bayar)}\n",
                          style: TextStyle(color: Colors.black54)),
                      TextSpan(
                          text:
                              "Total Sudah Dibayar: ${ConvertUtils.formatMoney(transaksi.bayar)}",
                          style: TextStyle(color: Colors.black54)),
                    ]),
                  )))
              .toList(),
        ));
  }
}
