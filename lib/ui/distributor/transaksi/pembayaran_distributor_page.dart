import 'package:division/division.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wholesale/bloc/distributor/transaksi/distributortransaksi_bloc.dart';
import 'package:wholesale/static_data.dart';
import 'package:wholesale/ui/components/grid_number.dart';
import 'package:wholesale/ui/distributor/transaksi/transasksi_distributor_page.dart';
import 'package:wholesale/utils/convert_utils.dart';

class PembayaranDistributorPage extends StatelessWidget {
  final controller = Get.find<TransaksiDistributorController>();
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(StaticData.screenWidth, StaticData.screenHeight),
        allowFontScaling: true);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Pembayaran Transaksi Toko"),
      ),
      body: BlocProvider(
        create: (context) => DistributorTransaksiBloc(),
        child: PembayaranDistributorView(controller: controller),
      ),
    );
  }
}

class PembayaranDistributorView extends StatelessWidget {
  PembayaranDistributorView({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final TransaksiDistributorController controller;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DistributorTransaksiBloc, DistributorTransaksiState>(
      listener: (context, state) {
        if (state is DistributorTransaksiStateSuccess) {
          Get.offAllNamed("/home");
          Flushbar(
              title: "Success",
              message: state.data['message'] ?? "",
              icon: Icon(
                Icons.check,
                color: Colors.greenAccent,
              ),
              duration: Duration(seconds: 2),
              flushbarPosition: FlushbarPosition.TOP)
            ..show(context);
        } else if (state is DistributorTransaksiStateError) {
          Flushbar(
              title: "Error",
              message: state.errors['message'] ?? "",
              duration: Duration(seconds: 5),
              icon: Icon(
                Icons.do_not_disturb,
                color: Colors.redAccent,
              ),
              flushbarPosition: FlushbarPosition.TOP)
            ..show(Get.context);
        }
      },
      builder: (context, state) {
        if (state is DistributorTransaksiStateLoading) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return PembayaranDistributorViewItem(controller: controller);
      },
    );
  }
}

class PembayaranDistributorViewItem extends StatelessWidget {
  DistributorTransaksiBloc bloc;
  PembayaranDistributorViewItem({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final TransaksiDistributorController controller;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<DistributorTransaksiBloc>(context);
    return Column(
      children: [
        Flexible(
          flex: 1,
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Txt("Total Bayar"),
                      Txt("${ConvertUtils.formatMoney(controller.jumlah_bayar.value)}")
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Txt("Kembalian"),
                      Obx(() => Txt(
                          "${ConvertUtils.formatMoney((controller.keranjang.value.bayar > controller.jumlah_bayar.value) ? controller.keranjang.value.bayar - controller.jumlah_bayar.value : 0)}"))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Divider(),
        Flexible(
          flex: 1,
          child: Container(
            color: Colors.white,
            child: Center(
              child: Obx(() => Txt(
                    "${ConvertUtils.formatMoney(controller.keranjang.value.bayar)}",
                    style: TxtStyle()..fontSize(18.ssp),
                  )),
            ),
          ),
        ),
        Divider(),
        Flexible(
          flex: 5,
          child: Row(
            children: [
              Flexible(
                  flex: 4,
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          children: [7, 8, 9]
                              .map((e) => Expanded(
                                      child: GridNumber(
                                    onTap: () {
                                      controller.keranjang.update((val) {
                                        val.bayar = int.parse(controller
                                                .keranjang.value.bayar
                                                .toString() +
                                            "$e");
                                      });
                                    },
                                    title: "$e",
                                  )))
                              .toList(),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [4, 5, 6]
                              .map((e) => Expanded(
                                      child: GridNumber(
                                    onTap: () {
                                      controller.keranjang.update((val) {
                                        val.bayar = int.parse(controller
                                                .keranjang.value.bayar
                                                .toString() +
                                            "$e");
                                      });
                                    },
                                    title: "$e",
                                  )))
                              .toList(),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [1, 2, 3]
                              .map((e) => Expanded(
                                      child: GridNumber(
                                    onTap: () {
                                      controller.keranjang.update((val) {
                                        val.bayar = int.parse(controller
                                                .keranjang.value.bayar
                                                .toString() +
                                            "$e");
                                      });
                                    },
                                    title: "$e",
                                  )))
                              .toList(),
                        ),
                      ),
                      Expanded(
                          child: Row(
                        children: [
                          Expanded(
                            child: Container(),
                          ),
                          Expanded(
                            child: GridNumber(
                              onTap: () {
                                controller.keranjang.update((val) {
                                  val.bayar = int.parse(controller
                                          .keranjang.value.bayar
                                          .toString() +
                                      "0");
                                });
                              },
                              title: "0",
                            ),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                        ],
                      )),
                    ],
                  )),
              Flexible(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          onPressed: () {
                            String bayar =
                                controller.keranjang.value.bayar.toString();
                            if (bayar.length > 1) {
                              controller.keranjang.update((val) {
                                val.bayar = int.parse(bayar.replaceRange(
                                    bayar.length - 1, bayar.length, ""));
                              });
                            } else {
                              controller.keranjang.update((val) {
                                val.bayar = 0;
                              });
                            }
                          },
                          color: Colors.white,
                          splashColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          icon: Icon(Icons.backspace, size: 25.ssp),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          onPressed: () {
                            controller.keranjang.update((val) {
                              val.bayar = 0;
                            });
                          },
                          color: Colors.white,
                          splashColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          icon: Icon(Icons.clear, size: 25.ssp),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Txt("Konfirmasi Transaksi"),
                                      actions: [
                                        FlatButton(
                                          child: Txt("Batal"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        FlatButton(
                                          child: Txt("Ya"),
                                          onPressed: () {
                                            bloc
                                              ..add(
                                                  DistributorTransaksiTambahEvent(
                                                      controller
                                                          .keranjang.value));
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                      content: TextFormField(
                                        decoration: InputDecoration(
                                            hintText: "Keterangan (optional)"),
                                        onChanged: (value) {
                                          controller.keranjang.update((val) {
                                            val.keterangan = value;
                                          });
                                        },
                                      ),
                                    ));
                          },
                          color: Colors.white,
                          splashColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          icon: Icon(Icons.check, size: 25.ssp),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
