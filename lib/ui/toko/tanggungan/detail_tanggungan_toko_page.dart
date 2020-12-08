import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wholesale/models/distributor_transaksi_model.dart';
import 'package:wholesale/static_data.dart';
import 'package:wholesale/utils/convert_utils.dart';
import 'package:wholesale/utils/date_time_utils.dart';

class DetailTanggunganTokoPage extends StatelessWidget {
  DistributorTransaksiModel tanggungan;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(StaticData.screenWidth, StaticData.screenHeight),
        allowFontScaling: true);
    tanggungan = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Tanggungan"),
      ),
      body: ListView(
        children: [
          ListTile(
            tileColor: Colors.white,
            title: Text("Waktu Tanggungan"),
            subtitle: Text("${DateTimeUtils.humanize(tanggungan.created_at)}"),
          ),
          ListTile(
            tileColor: Colors.white,
            title: Text("Keterangan"),
            subtitle: Text("${tanggungan.keterangan}"),
          ),
          ListTile(
            tileColor: Colors.white,
            title: Text("Status"),
            subtitle: Text("${(tanggungan.status) ? "Sudah" : "Belum"} Lunas"),
          ),
          ListTile(
            tileColor: Colors.white,
            title: Text("Total Bayar"),
            subtitle:
                Text("Rp${ConvertUtils.formatMoney(tanggungan.total_bayar)}"),
          ),
        ],
      ),
    );
  }
}
