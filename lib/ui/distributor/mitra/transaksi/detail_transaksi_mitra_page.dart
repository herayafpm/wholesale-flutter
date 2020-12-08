import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wholesale/models/distributor_transaksi_model.dart';
import 'package:wholesale/static_data.dart';
import 'package:wholesale/utils/convert_utils.dart';
import 'package:wholesale/utils/date_time_utils.dart';

class DetailTransaksiMitraPage extends StatelessWidget {
  DistributorTransaksiModel transaksi;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(StaticData.screenWidth, StaticData.screenHeight),
        allowFontScaling: true);
    transaksi = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Transaksi"),
      ),
      body: ListView(
        children: [
          ListTile(
            tileColor: Colors.white,
            title: Text("Toko"),
            subtitle: Text("${transaksi.toko.nama}"),
          ),
          ListTile(
            tileColor: Colors.white,
            title: Text("Waktu Transaksi"),
            subtitle: Text("${DateTimeUtils.humanize(transaksi.created_at)}"),
          ),
          ListTile(
            tileColor: Colors.white,
            title: Text("Keterangan"),
            subtitle: Text("${transaksi.keterangan}"),
          ),
          ListTile(
            tileColor: Colors.white,
            title: Text("Status"),
            subtitle: Text("${(transaksi.status) ? "Sudah" : "Belum"} Lunas"),
          ),
          ListTile(
            tileColor: Colors.white,
            title: Text("Total Bayar"),
            subtitle:
                Text("Rp${ConvertUtils.formatMoney(transaksi.total_bayar)}"),
          ),
        ],
      ),
    );
  }
}
