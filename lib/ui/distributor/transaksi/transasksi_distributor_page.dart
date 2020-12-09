import 'package:cached_network_image/cached_network_image.dart';
import 'package:division/division.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wholesale/bloc/distributor/barang/distributor_barang_bloc.dart';
import 'package:wholesale/models/distributor_barang_model.dart';
import 'package:wholesale/models/distributor_transaksi_model.dart';
import 'package:wholesale/models/toko_model.dart';
import 'package:wholesale/static_data.dart';
import 'package:wholesale/utils/convert_utils.dart';

class TransaksiDistributorController extends GetxController {
  final toko = TokoModel().obs;
  final keranjang = DistributorTransaksiModel().obs;
  final jumlah_belanja = 0.obs;
  final jumlah = 0.obs;
  final harga_jual = 0.obs;
  final jumlah_bayar = 0.obs;
  final kembalian = 0.obs;
  final istapplus = false.obs;
  final istapmin = false.obs;

  @override
  void onInit() {
    keranjang.value.toko = Get.arguments;
    keranjang.value.barangs = [];
    keranjang.value.jumlahs = [];
    keranjang.value.harga_juals = [];
    keranjang.value.bayar = 0;
    toko.value = Get.arguments;
    super.onInit();
  }

  void updateJumlahBelanja() {
    jumlah_belanja.value = 0;
    jumlah_bayar.value = 0;
    if (keranjang.value.barangs.length > 0) {
      int total = 0;
      int no = 0;
      for (var jumlah in keranjang.value.jumlahs) {
        total += jumlah;
        jumlah_bayar.value += keranjang.value.harga_juals[no] * jumlah;
        no++;
      }
      jumlah_belanja.value = (keranjang.value.barangs.length *
              (total / keranjang.value.jumlahs.length))
          .round();
    }
  }
}

class TransaksiDistributorPage extends StatelessWidget {
  final controller = Get.put(TransaksiDistributorController());
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(StaticData.screenWidth, StaticData.screenHeight),
        allowFontScaling: true);
    return Scaffold(
      appBar: AppBar(
        title:
            Obx(() => Text("Tambah Barang Toko ${controller.toko.value.nama}")),
      ),
      body: Stack(
        children: [
          BlocProvider<DistributorBarangBloc>(
            create: (context) =>
                DistributorBarangBloc()..add(DistributorBarangGetListEvent()),
            child: TransaksiDistributorView(),
          ),
          Positioned(
              bottom: 0.03.sh,
              right: 0.1.sw,
              left: 0.1.sw,
              child: Parent(
                  gesture: Gestures()
                    ..onTap(() {
                      if (controller.keranjang.value.barangs.length > 0) {
                        Get.toNamed("keranjangdistributor");
                      }
                    }),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Txt("Lihat Keranjang",
                          style: TxtStyle()
                            ..textColor(Colors.white)
                            ..fontSize(14.ssp)
                            ..fontWeight(FontWeight.bold)),
                      Obx(() => Txt("${controller.jumlah_belanja} Pesanan",
                          style: TxtStyle()
                            ..textColor(Colors.white)
                            ..fontSize(12.ssp))),
                      Obx(() => Txt(
                          "Rp${ConvertUtils.formatMoney(controller.jumlah_bayar.value)}",
                          style: TxtStyle()
                            ..textColor(Colors.white)
                            ..fontSize(12.ssp)
                            ..fontWeight(FontWeight.bold))),
                    ],
                  ),
                  style: ParentStyle()
                    ..background
                        .color(Theme.of(context).scaffoldBackgroundColor)
                    ..height(0.06.sh)
                    ..borderRadius(all: 10)
                    ..ripple(true, splashColor: Colors.white)
                    ..elevation(4))),
        ],
      ),
    );
  }
}

class TransaksiDistributorView extends StatelessWidget {
  final controller = Get.find<TransaksiDistributorController>();
  DistributorBarangBloc bloc;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    bloc..add(DistributorBarangGetListEvent(refresh: true));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    bloc..add(DistributorBarangGetListEvent());
    _refreshController.loadComplete();
  }

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<DistributorBarangBloc>(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    bloc
                      ..add(DistributorBarangGetListEvent(
                          refresh: true, search: searchController.text));
                  },
                ),
                filled: true,
                hintText: "Search",
                fillColor: Colors.white),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            padding: EdgeInsets.only(bottom: 0.06.sh),
            color: Colors.white,
            child: BlocConsumer<DistributorBarangBloc, DistributorBarangState>(
              listener: (context, state) {
                if (state is DistributorBarangStateError) {
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
                } else if (state is DistributorBarangStateSuccess) {
                  Flushbar(
                    title: "Success",
                    message: state.data['message'] ?? "",
                    duration: Duration(seconds: 5),
                    icon: Icon(
                      Icons.check,
                      color: Colors.greenAccent,
                    ),
                    flushbarPosition: FlushbarPosition.TOP,
                  )..show(Get.context);
                }
              },
              builder: (context, state) {
                if (state is DistributorBarangListLoaded) {
                  DistributorBarangListLoaded stateData = state;
                  if (stateData.distributorBarangs != null &&
                      stateData.distributorBarangs.length > 0) {
                    return SmartRefresher(
                      controller: _refreshController,
                      enablePullDown: true,
                      enablePullUp: true,
                      header: WaterDropMaterialHeader(
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      onRefresh: _onRefresh,
                      onLoading: _onLoading,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        itemCount: stateData.distributorBarangs.length,
                        itemBuilder: (context, index) {
                          DistributorBarangModel barang =
                              stateData.distributorBarangs[index];

                          return Parent(
                            gesture: Gestures()
                              ..onTap(() {
                                bool ismine = false;
                                int index = 0;
                                controller.jumlah.value = 0;
                                controller.harga_jual.value = barang.harga_jual;
                                int no = 0;
                                for (DistributorBarangModel keranjangBarang
                                    in controller.keranjang.value.barangs) {
                                  if (keranjangBarang.id == barang.id) {
                                    controller.jumlah.value =
                                        controller.keranjang.value.jumlahs[no];
                                    controller.harga_jual.value = controller
                                        .keranjang.value.harga_juals[no];
                                    ismine = true;
                                    index = no;
                                  }
                                  no++;
                                }
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (context) => Parent(
                                    style: ParentStyle()
                                      ..background.color(Colors.grey[100])
                                      ..height(0.8.sh)
                                      ..borderRadius(topRight: 20, topLeft: 20)
                                      ..elevation(10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Icon(Icons.minimize,
                                              size: 24.ssp),
                                        ),
                                        SizedBox(height: 20),
                                        Flexible(
                                            flex: 3,
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(10),
                                                  color: Colors.white,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Txt(
                                                            "${barang.nama_barang}",
                                                            style: TxtStyle()
                                                              ..fontSize(
                                                                  18..ssp)
                                                              ..fontWeight(
                                                                  FontWeight
                                                                      .bold),
                                                          ),
                                                          SizedBox(height: 5),
                                                          Txt(
                                                            "${barang.keterangan}",
                                                            style: TxtStyle()
                                                              ..textColor(Colors
                                                                  .black54)
                                                              ..fontSize(
                                                                  12..ssp),
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Txt(
                                                            "${ConvertUtils.formatMoney(barang.harga_jual)}",
                                                            style: TxtStyle()
                                                              ..fontSize(
                                                                  18..ssp)
                                                              ..fontWeight(
                                                                  FontWeight
                                                                      .bold),
                                                          ),
                                                          SizedBox(height: 5),
                                                          Txt(
                                                            "Harga jual",
                                                            style: TxtStyle()
                                                              ..textColor(Colors
                                                                  .black54)
                                                              ..fontSize(
                                                                  12..ssp),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Container(
                                                  padding: EdgeInsets.all(10),
                                                  color: Colors.white,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Txt(
                                                            "Jenis Barang",
                                                            style: TxtStyle()
                                                              ..fontSize(
                                                                  12..ssp)
                                                              ..fontWeight(
                                                                  FontWeight
                                                                      .bold),
                                                          ),
                                                          SizedBox(height: 5),
                                                          Txt(
                                                            "${barang.jenis_barang_nama}",
                                                            style: TxtStyle()
                                                              ..textColor(Colors
                                                                  .black54)
                                                              ..fontSize(
                                                                  12..ssp),
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Txt(
                                                            "Ukuran Barang",
                                                            style: TxtStyle()
                                                              ..fontSize(
                                                                  12..ssp)
                                                              ..fontWeight(
                                                                  FontWeight
                                                                      .bold),
                                                          ),
                                                          SizedBox(height: 5),
                                                          Txt(
                                                            "${barang.ukuran_barang_nama}",
                                                            style: TxtStyle()
                                                              ..textColor(Colors
                                                                  .black54)
                                                              ..fontSize(
                                                                  12..ssp),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Container(
                                                  padding: EdgeInsets.all(10),
                                                  color: Colors.white,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Txt(
                                                            "Stok",
                                                            style: TxtStyle()
                                                              ..fontSize(
                                                                  12..ssp)
                                                              ..fontWeight(
                                                                  FontWeight
                                                                      .bold),
                                                          ),
                                                          SizedBox(height: 5),
                                                          Obx(
                                                            () => Txt(
                                                              "${ConvertUtils.formatMoney(barang.stok - controller.jumlah.value)}",
                                                              style: TxtStyle()
                                                                ..textColor(
                                                                    Colors
                                                                        .black54)
                                                                ..fontSize(
                                                                    12..ssp),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Container(
                                                  padding: EdgeInsets.all(10),
                                                  color: Colors.white,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      GestureDetector(
                                                        onLongPressStart:
                                                            (_) async {
                                                          controller.istapmin
                                                              .value = true;
                                                          do {
                                                            if (controller
                                                                    .jumlah
                                                                    .value >
                                                                0) {
                                                              controller.jumlah
                                                                  .value--;
                                                            } else {
                                                              controller
                                                                      .istapmin
                                                                      .value =
                                                                  false;
                                                            }
                                                            await Future.delayed(
                                                                Duration(
                                                                    milliseconds:
                                                                        100));
                                                          } while (controller
                                                              .istapmin.value);
                                                        },
                                                        onLongPressEnd: (_) =>
                                                            controller.istapmin
                                                                .value = false,
                                                        onTap: () {
                                                          if (controller.jumlah
                                                                  .value >
                                                              0) {
                                                            controller
                                                                .jumlah.value--;
                                                          }
                                                        },
                                                        child:
                                                            Icon(Icons.remove),
                                                      ),
                                                      Obx(() => Txt(
                                                            "${controller.jumlah.value}",
                                                            style: TxtStyle()
                                                              ..textColor(Colors
                                                                  .black54)
                                                              ..fontSize(
                                                                  15..ssp),
                                                          )),
                                                      GestureDetector(
                                                        onLongPressStart:
                                                            (_) async {
                                                          controller.istapplus
                                                              .value = true;
                                                          do {
                                                            if (controller
                                                                    .jumlah
                                                                    .value <
                                                                barang.stok) {
                                                              controller.jumlah
                                                                  .value++;
                                                            } else {
                                                              controller
                                                                      .istapplus
                                                                      .value =
                                                                  false;
                                                            }
                                                            await Future.delayed(
                                                                Duration(
                                                                    milliseconds:
                                                                        100));
                                                          } while (controller
                                                              .istapplus.value);
                                                        },
                                                        onLongPressEnd: (_) =>
                                                            controller.istapplus
                                                                .value = false,
                                                        onTap: () {
                                                          if (controller.jumlah
                                                                  .value <
                                                              barang.stok) {
                                                            controller
                                                                .jumlah.value++;
                                                          }
                                                        },
                                                        child: Icon(Icons.add),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Container(
                                                  padding: EdgeInsets.all(10),
                                                  color: Colors.white,
                                                  child: Obx(() =>
                                                      TextFormField(
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        initialValue: controller
                                                            .harga_jual.value
                                                            .toString(),
                                                        onChanged: (val) {
                                                          controller.harga_jual
                                                                  .value =
                                                              int.parse(val);
                                                        },
                                                      )),
                                                ),
                                              ],
                                            )),
                                        SizedBox(height: 20),
                                        Parent(
                                            gesture: Gestures()
                                              ..onTap(() {
                                                if (ismine) {
                                                  if (controller.jumlah.value <=
                                                      0) {
                                                    controller
                                                        .keranjang.value.barangs
                                                        .removeAt(index);
                                                    controller
                                                        .keranjang.value.jumlahs
                                                        .removeAt(index);
                                                    controller.keranjang.value
                                                        .harga_juals
                                                        .removeAt(index);
                                                  } else {
                                                    controller.keranjang.value
                                                            .jumlahs[index] =
                                                        controller.jumlah.value;
                                                    controller.keranjang.value
                                                                .harga_juals[
                                                            index] =
                                                        controller
                                                            .harga_jual.value;
                                                  }
                                                } else {
                                                  if (controller.jumlah.value >
                                                      0) {
                                                    controller
                                                        .keranjang.value.barangs
                                                        .add(barang);
                                                    controller
                                                        .keranjang.value.jumlahs
                                                        .add(controller
                                                            .jumlah.value);
                                                    controller.keranjang.value
                                                        .harga_juals
                                                        .add(controller
                                                            .harga_jual.value);
                                                  }
                                                }
                                                controller
                                                    .updateJumlahBelanja();
                                                _onRefresh();
                                                Navigator.pop(context);
                                              }),
                                            child: Txt(
                                                (ismine)
                                                    ? "Ubah Jumlah Barang"
                                                    : "Tambahkan Ke Keranjang",
                                                style: TxtStyle()
                                                  ..textColor(Colors.white)
                                                  ..fontSize(14.ssp)
                                                  ..fontWeight(FontWeight.bold)
                                                  ..textAlign.center()
                                                  ..alignment.center()),
                                            style: ParentStyle()
                                              ..background.color(
                                                  Theme.of(context)
                                                      .scaffoldBackgroundColor)
                                              ..width(1.sw)
                                              ..height(0.08.sh)
                                              ..ripple(true,
                                                  splashColor: Colors.white))
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            child: Container(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Flexible(
                                      flex: 3,
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                "${StaticData.baseUrl}/uploads/${barang.foto ?? 'kosong.png'}",
                                            fit: BoxFit.fill,
                                            placeholder: (context, url) =>
                                                new CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    new Icon(Icons.error),
                                          ))),
                                  Flexible(
                                      flex: 1,
                                      child: Obx(() {
                                        int jumlah = 0;
                                        int no = 0;
                                        for (DistributorBarangModel keranjangBarang
                                            in controller
                                                .keranjang.value.barangs) {
                                          if (keranjangBarang.id == barang.id) {
                                            jumlah = controller
                                                .keranjang.value.jumlahs[no];
                                          }
                                          no++;
                                        }
                                        if (jumlah == 0) {
                                          return Text("${barang.nama_barang}");
                                        } else {
                                          return RichText(
                                            text: TextSpan(children: [
                                              TextSpan(
                                                  text: "${jumlah}x ",
                                                  style: TextStyle(
                                                      color:
                                                          Colors.green[300])),
                                              TextSpan(
                                                  text: "${barang.nama_barang}",
                                                  style: TextStyle(
                                                      color: Colors.black)),
                                            ]),
                                          );
                                        }
                                      }))
                                ],
                              ),
                            ),
                            style: ParentStyle()..margin(all: 5),
                          );
                        },
                      ),
                    );
                  } else {
                    return Container(
                      child: Center(
                          child: Txt(
                        "Anda Belum Pernah Melakukan Penambahan Barang",
                        style: TxtStyle()
                          ..fontSize(30.sp)
                          ..textColor(Colors.white)
                          ..textAlign.center(),
                      )),
                    );
                  }
                }
                return Container(
                  child: Center(
                      child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  )),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
