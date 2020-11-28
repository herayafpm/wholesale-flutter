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
import 'package:wholesale/models/toko_model.dart';
import 'package:wholesale/static_data.dart';

class TransaksiDistributorPage extends StatelessWidget {
  TokoModel toko;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(StaticData.screenWidth, StaticData.screenHeight),
        allowFontScaling: true);
    toko = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Barang Toko ${toko.nama}"),
      ),
      body: Stack(
        children: [
          BlocProvider<DistributorBarangBloc>(
            create: (context) =>
                DistributorBarangBloc()..add(DistributorBarangGetListEvent()),
            child: TransaksiDistributorView(),
          ),
          Positioned(
              bottom: 20,
              right: 20,
              child: Stack(
                children: [
                  Positioned(
                    top: -5,
                    right: -5,
                    child: Parent(
                        child: Txt("10",
                            style: TxtStyle()
                              ..textColor(Colors.black)
                              ..textAlign.center()
                              ..alignment.center()),
                        style: ParentStyle()
                          ..background.color(Colors.white)
                          ..height(25)
                          ..width(25)
                          ..borderRadius(all: 50)),
                  ),
                  FloatingActionButton(
                    isExtended: true,
                    child: Icon(Icons.shopping_bag),
                    onPressed: () {
                      Get.toNamed("/distributortambahbarang");
                    },
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

class TransaksiDistributorView extends StatelessWidget {
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
                                Get.toNamed("/distributorbarang",
                                    arguments: barang);
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
                                      flex: 1, child: Txt(barang.nama_barang))
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
