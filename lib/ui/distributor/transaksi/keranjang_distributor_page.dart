import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wholesale/models/distributor_barang_model.dart';
import 'package:wholesale/static_data.dart';
import 'package:wholesale/ui/distributor/transaksi/transasksi_distributor_page.dart';
import 'package:wholesale/utils/convert_utils.dart';

class KeranjangDistributorPage extends StatelessWidget {
  final transaksiDistributorController =
      Get.find<TransaksiDistributorController>();
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(StaticData.screenWidth, StaticData.screenHeight),
        allowFontScaling: true);
    return Scaffold(
      appBar: AppBar(
          title: Text(
              "Keranjang Toko ${transaksiDistributorController.toko.value.nama}")),
      body: Stack(
        children: [
          ListView.builder(
            itemCount:
                transaksiDistributorController.keranjang.value.barangs.length,
            itemBuilder: (BuildContext context, int index) {
              DistributorBarangModel barang =
                  transaksiDistributorController.keranjang.value.barangs[index];
              int harga_jual = transaksiDistributorController
                  .keranjang.value.harga_juals[index];
              int jumlah =
                  transaksiDistributorController.keranjang.value.jumlahs[index];
              return ListTile(
                title: Text(barang.nama_barang),
                subtitle: Text(
                    "Jumlah ${jumlah}x, harga satuan Rp${ConvertUtils.formatMoney(harga_jual)}"),
                tileColor: Colors.white,
              );
            },
          ),
          Positioned(
              bottom: 0.03.sh,
              right: 0.1.sw,
              left: 0.1.sw,
              child: Parent(
                  gesture: Gestures()
                    ..onTap(() {
                      Get.toNamed("/pemabayarandistributor");
                    }),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Txt("Bayar",
                          style: TxtStyle()
                            ..textColor(
                                Theme.of(context).scaffoldBackgroundColor)
                            ..fontSize(14.ssp)
                            ..fontWeight(FontWeight.bold)),
                      Obx(() => Txt(
                          "${transaksiDistributorController.jumlah_belanja} Pesanan",
                          style: TxtStyle()
                            ..textColor(
                                Theme.of(context).scaffoldBackgroundColor)
                            ..fontSize(12.ssp))),
                      Obx(() => Txt(
                          "Rp${ConvertUtils.formatMoney(transaksiDistributorController.jumlah_bayar.value)}",
                          style: TxtStyle()
                            ..textColor(
                                Theme.of(context).scaffoldBackgroundColor)
                            ..fontSize(12.ssp)
                            ..fontWeight(FontWeight.bold))),
                    ],
                  ),
                  style: ParentStyle()
                    ..background.color(Colors.white)
                    ..height(0.06.sh)
                    ..borderRadius(all: 10)
                    ..ripple(true,
                        splashColor: Theme.of(context).scaffoldBackgroundColor)
                    ..elevation(4))),
        ],
      ),
    );
  }
}
