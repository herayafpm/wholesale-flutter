import 'package:division/division.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wholesale/bloc/distributor/toko/distributortoko_bloc.dart';
import 'package:wholesale/models/toko_model.dart';
import 'package:wholesale/static_data.dart';

class ManajemenMitraPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(StaticData.screenWidth, StaticData.screenHeight),
        allowFontScaling: true);
    return Stack(
      children: [
        BlocProvider<DistributorTokoBloc>(
          create: (context) =>
              DistributorTokoBloc()..add(DistributorTokoGetListEvent()),
          child: ManajemenMitraView(),
        ),
        Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Get.toNamed("/tambahmitra");
              },
            )),
      ],
    );
  }
}

class ManajemenMitraView extends StatelessWidget {
  DistributorTokoBloc bloc;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    bloc..add(DistributorTokoGetListEvent(refresh: true));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    bloc..add(DistributorTokoGetListEvent());
    _refreshController.loadComplete();
  }

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<DistributorTokoBloc>(context);
    return Column(
      children: [
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
                      ..add(DistributorTokoGetListEvent(
                          refresh: true, search: searchController.text));
                  },
                ),
                filled: true,
                hintText: "Cari Toko...",
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
                if (state is DistributorTokoListLoaded) {
                  DistributorTokoListLoaded stateData = state;
                  if (stateData.tokos != null && stateData.tokos.length > 0) {
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
                        itemCount: stateData.tokos.length,
                        itemBuilder: (BuildContext context, int index) {
                          TokoModel toko = stateData.tokos[index];
                          return Container(
                            margin: EdgeInsets.all(5),
                            child: ListTile(
                              leading: (toko.utang)
                                  ? Icon(
                                      Icons.clear,
                                      color: Colors.redAccent,
                                    )
                                  : null,
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title:
                                              Text("Detail Toko ${toko.nama}"),
                                          content: Container(
                                            width: 0.8.sw,
                                            child: RichText(
                                              text: TextSpan(children: [
                                                TextSpan(
                                                    text:
                                                        "Email \t ${toko.email}\n",
                                                    style: TextStyle(
                                                        color: Colors.black)),
                                                TextSpan(
                                                    text:
                                                        "Alamat \t ${toko.alamat}\n",
                                                    style: TextStyle(
                                                        color: Colors.black)),
                                                TextSpan(
                                                    text:
                                                        "No Telp Toko \t ${toko.no_telp ?? ""}\n",
                                                    style: TextStyle(
                                                        color: Colors.black)),
                                              ]),
                                            ),
                                          ),
                                        ));
                              },
                              trailing: PopupMenuButton<String>(
                                onSelected: (choice) {
                                  if (choice == "Tambah Barang") {
                                    Get.toNamed("/transaksidistributor",
                                        arguments: toko);
                                  } else if (choice == "Manajemen Transaksi") {
                                    Get.toNamed("/manajementransaksimitra",
                                        arguments: toko);
                                  } else if (choice == "List Barang") {
                                    Get.toNamed("/listbarangmitra",
                                        arguments: toko);
                                  } else if (choice == "Hapus") {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: Text(
                                                  "Konfirmasi hapus Toko ${toko.nama}"),
                                              content: Text(
                                                  "Yakin ingin menghpapus Toko ${toko.nama}"),
                                              actions: [
                                                FlatButton(
                                                    child: Text("Batal"),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    }),
                                                FlatButton(
                                                    child: Text("Ya"),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      bloc
                                                        ..add(
                                                            DistributorTokoDeleteEvent(
                                                                toko.id));
                                                    }),
                                              ],
                                            ));
                                  }
                                },
                                itemBuilder: (BuildContext context) {
                                  return [
                                    "Tambah Barang",
                                    "Manajemen Transaksi",
                                    "List Barang",
                                    "Hapus"
                                  ].map((String choice) {
                                    return PopupMenuItem<String>(
                                      value: choice,
                                      child: Text(choice + " Toko"),
                                    );
                                  }).toList();
                                },
                              ),
                              tileColor: Colors.white,
                              title: Txt(toko.nama),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return Container(
                      child: Center(
                          child: Txt(
                        "Anda belum menambahkan toko",
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
                    child: Text("Anda belum menambahkan toko"),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
