import 'package:cached_network_image/cached_network_image.dart';
import 'package:division/division.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wholesale/bloc/toko/barang/toko_barang_bloc.dart';
import 'package:wholesale/controllers/home_controller.dart';
import 'package:wholesale/models/toko_barang_model.dart';
import 'package:wholesale/static_data.dart';

class ManajemenBarangTokoPage extends StatelessWidget {
  final homeController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(StaticData.screenWidth, StaticData.screenHeight),
        allowFontScaling: true);
    return BlocProvider<TokoBarangBloc>(
      create: (context) => TokoBarangBloc()..add(TokoBarangGetListEvent()),
      child: ManajemenBarangTokoView(),
    );
  }
}

class ManajemenBarangTokoView extends StatelessWidget {
  TokoBarangBloc bloc;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    bloc..add(TokoBarangGetListEvent(refresh: true));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    bloc..add(TokoBarangGetListEvent());
    _refreshController.loadComplete();
  }

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<TokoBarangBloc>(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: searchController,
            decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    bloc
                      ..add(TokoBarangGetListEvent(
                          refresh: true, search: searchController.text));
                  },
                ),
                filled: true,
                hintText: "Cari Barang...",
                fillColor: Colors.white),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            color: Colors.white,
            child: BlocConsumer<TokoBarangBloc, TokoBarangState>(
              listener: (context, state) {
                if (state is TokoBarangStateError) {
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
                } else if (state is TokoBarangStateSuccess) {
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
                if (state is TokoBarangListLoaded) {
                  TokoBarangListLoaded stateData = state;
                  if (stateData.tokoBarangs != null &&
                      stateData.tokoBarangs.length > 0) {
                    return GestureDetector(
                      onTap: () {},
                      child: SmartRefresher(
                        controller: _refreshController,
                        enablePullDown: true,
                        enablePullUp: true,
                        header: WaterDropMaterialHeader(
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        onRefresh: _onRefresh,
                        onLoading: _onLoading,
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          itemCount: stateData.tokoBarangs.length,
                          itemBuilder: (context, index) {
                            TokoBarangModel barang =
                                stateData.tokoBarangs[index];
                            return Parent(
                              gesture: Gestures()
                                ..onTap(() {
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                  Get.toNamed("/detailbarangtoko",
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
