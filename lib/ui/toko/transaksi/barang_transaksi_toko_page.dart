import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wholesale/models/toko_barang_model.dart';
import 'package:wholesale/models/toko_transaksi_model.dart';
import 'package:wholesale/static_data.dart';
import 'package:wholesale/utils/convert_utils.dart';

// ignore: must_be_immutable
class BarangTransaksiTokoPage extends StatelessWidget {
  TokoTransaksiModel transaksi;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(StaticData.screenWidth, StaticData.screenHeight),
        allowFontScaling: true);
    transaksi = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Barang Transaksi"),
      ),
      body: ListView(
          children: transaksi.barangs
              .asMap()
              .map((index, e) => MapEntry(
                  index,
                  ListTile(
                      onTap: () {
                        TokoBarangModel barang = TokoBarangModel(id: e.id);
                        Get.toNamed("/detailbarangtoko", arguments: barang);
                      },
                      tileColor: Colors.white,
                      title: Text("${e.nama_barang}"),
                      subtitle: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text:
                                  "Jumlah Pesanan: ${ConvertUtils.formatMoney(transaksi.jumlahs[index])}\n",
                              style: TextStyle(color: Colors.black54)),
                          TextSpan(
                              text:
                                  "Harga Jual: Rp${ConvertUtils.formatMoney(transaksi.harga_juals[index])}",
                              style: TextStyle(color: Colors.black54)),
                        ]),
                      ))))
              .values
              .toList()),
    );
  }
}
