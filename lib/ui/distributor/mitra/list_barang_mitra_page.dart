import 'package:division/division.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wholesale/bloc/distributor/toko/distributortoko_bloc.dart';
import 'package:wholesale/models/distributor_barang_model.dart';
import 'package:wholesale/models/toko_model.dart';
import 'package:wholesale/static_data.dart';
import 'package:get/get.dart';
import 'package:wholesale/utils/convert_utils.dart';

class ListBarangMitraController extends GetxController {
  final toko = TokoModel().obs;
  @override
  void onInit() {
    toko.value = Get.arguments;
    super.onInit();
  }
}

// ignore: must_be_immutable
class ListBarangMitraPage extends StatelessWidget {
  final controller = Get.put(ListBarangMitraController());
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(StaticData.screenWidth, StaticData.screenHeight),
        allowFontScaling: true);
    return Scaffold(
      appBar: AppBar(
        title: Text("Barang Mitra ${controller.toko.value.nama}"),
      ),
      body: BlocProvider(
        create: (context) => DistributorTokoBloc()
          ..add(DistributorTokoGetListBarangEvent(
              toko_id: controller.toko.value.id)),
        child: ListBarangMitraView(),
      ),
    );
  }
}

class ListBarangMitraView extends StatelessWidget {
  final controller = Get.find<ListBarangMitraController>();
  DistributorTokoBloc bloc;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    bloc
      ..add(DistributorTokoGetListBarangEvent(
          toko_id: controller.toko.value.id, refresh: true));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    bloc
      ..add(
          DistributorTokoGetListBarangEvent(toko_id: controller.toko.value.id));
    _refreshController.loadComplete();
  }

  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<DistributorTokoBloc>(context);
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: searchController,
          focusNode: FocusNode(),
          decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  bloc
                    ..add(DistributorTokoGetListBarangEvent(
                        toko_id: controller.toko.value.id,
                        refresh: true,
                        search: searchController.text));
                },
              ),
              filled: true,
              hintText: "Cari Barang Toko...",
              fillColor: Colors.white),
        ),
      ),
      Flexible(
          flex: 1,
          child: GestureDetector(
              onTap: () {},
              child: BlocConsumer<DistributorTokoBloc, DistributorTokoState>(
                listener: (context, state) {
                  if (state is DistributorTokoStateError) {
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
                  } else if (state is DistributorTokoStateSuccess) {
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
                  if (state is DistributorBarangTokoListLoaded) {
                    DistributorBarangTokoListLoaded stateData = state;
                    if (stateData.barangs != null &&
                        stateData.barangs.length > 0) {
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
                              itemCount: stateData.barangs.length,
                              itemBuilder: (BuildContext context, int index) {
                                DistributorBarangModel barang =
                                    stateData.barangs[index];
                                return ListTile(
                                    onTap: () {
                                      Get.toNamed("/distributorbarang",
                                          arguments: barang);
                                    },
                                    tileColor: Colors.white,
                                    title: Text("${barang.nama_barang}"),
                                    subtitle: RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                            text:
                                                "Stok: ${ConvertUtils.formatMoney(barang.stok)}\n",
                                            style: TextStyle(
                                                color: Colors.black54)),
                                        TextSpan(
                                            text:
                                                "Harga Jual: Rp${ConvertUtils.formatMoney(barang.harga_jual)}",
                                            style: TextStyle(
                                                color: Colors.black54)),
                                      ]),
                                    ));
                              }));
                    } else {
                      return Container(
                        child: Center(
                            child: Txt(
                          "Tidak ditemukan barang toko",
                          style: TxtStyle()
                            ..fontSize(22.ssp)
                            ..textColor(Colors.white)
                            ..textAlign.center(),
                        )),
                      );
                    }
                  }
                  return Container(
                    child: Center(
                        child: Txt(
                      "Toko ini belum menambahkan barang",
                      style: TxtStyle()
                        ..fontSize(22.ssp)
                        ..textColor(Colors.white)
                        ..textAlign.center(),
                    )),
                  );
                },
              )))
    ]);
  }
}
