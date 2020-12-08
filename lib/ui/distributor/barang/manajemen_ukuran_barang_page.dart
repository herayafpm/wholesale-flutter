import 'package:division/division.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wholesale/bloc/distributor/barang/ukuran/ukuran_barang_bloc.dart';
import 'package:wholesale/models/ukuran_barang_model.dart';
import 'package:wholesale/static_data.dart';

class ManajemenUkuranBarangPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(StaticData.screenWidth, StaticData.screenHeight),
        allowFontScaling: true);
    return Scaffold(
      appBar: AppBar(
        title: Txt("Manajemen Ukuran Barang"),
      ),
      body: BlocProvider<UkuranBarangBloc>(
        create: (context) =>
            UkuranBarangBloc()..add(UkuranBarangGetListEvent()),
        child: ManajemenUkuranBarangView(),
      ),
    );
  }
}

class ManajemenUkuranBarangView extends StatelessWidget {
  UkuranBarangBloc bloc;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    bloc..add(UkuranBarangGetListEvent(refresh: true));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    bloc..add(UkuranBarangGetListEvent());
    _refreshController.loadComplete();
  }

  GlobalKey<FormState> _key = GlobalKey<FormState>();
  String nama = "";
  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<UkuranBarangBloc>(context);
    return Stack(
      children: [
        Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: BlocConsumer<UkuranBarangBloc, UkuranBarangState>(
            listener: (context, state) {
              if (state is UkuranBarangStateError) {
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
              } else if (state is UkuranBarangStateSuccess) {
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
              if (state is UkuranBarangListLoaded) {
                UkuranBarangListLoaded stateData = state;
                if (stateData.ukuranBarangs != null &&
                    stateData.ukuranBarangs.length > 0) {
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
                      itemCount: stateData.ukuranBarangs.length,
                      itemBuilder: (context, index) {
                        UkuranBarangModel ukuran =
                            stateData.ukuranBarangs[index];
                        return Container(
                          margin: EdgeInsets.all(5),
                          child: ListTile(
                            title: Txt(ukuran.nama),
                            tileColor: Colors.white,
                            trailing: PopupMenuButton<String>(
                              onSelected: (choice) {
                                if (choice == "ubah") {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: Txt("Ubah ${ukuran.nama}"),
                                            actions: [
                                              FlatButton(
                                                child: Txt("Batal"),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              FlatButton(
                                                child: Txt("Ubah"),
                                                onPressed: () {
                                                  if (_key.currentState
                                                      .validate()) {
                                                    _key.currentState.save();
                                                    ukuran.nama = nama;
                                                    bloc
                                                      ..add(
                                                          UkuranBarangEditEvent(
                                                              ukuran));
                                                    Navigator.pop(context);
                                                  }
                                                },
                                              ),
                                            ],
                                            content: Form(
                                              key: _key,
                                              child: TextFormField(
                                                decoration: InputDecoration(
                                                    hintText:
                                                        "Masukkan Nama Ukuran Barang"),
                                                initialValue: ukuran.nama,
                                                validator: (value) {
                                                  if (value.isEmpty) {
                                                    return "Ukuran Barang tidak boleh kosong";
                                                  }
                                                  return null;
                                                },
                                                onSaved: (value) {
                                                  nama = value;
                                                },
                                              ),
                                            ),
                                          ));
                                } else if (choice == "hapus") {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: Txt("Hapus ${ukuran.nama}"),
                                            content: Txt(
                                                "Yakin ingin menghapus ${ukuran.nama}?"),
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
                                                        UkuranBarangDeleteEvent(
                                                            ukuran.id));
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          ));
                                }
                              },
                              itemBuilder: (BuildContext context) {
                                return ["ubah", "hapus"].map((String choice) {
                                  return PopupMenuItem<String>(
                                    value: choice,
                                    child: Text(choice.capitalizeFirst +
                                        " Ukuran Barang"),
                                  );
                                }).toList();
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return Container(
                    child: Center(
                        child: Txt(
                      "Anda Belum Pernah Melakukan Penambahan Ukuran Barang",
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
        Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Txt("Tambah Ukuran Barang"),
                          actions: [
                            FlatButton(
                              child: Txt("Batal"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            FlatButton(
                              child: Txt("Tambah"),
                              onPressed: () {
                                if (_key.currentState.validate()) {
                                  _key.currentState.save();
                                  UkuranBarangModel ukuran =
                                      UkuranBarangModel(nama: nama);
                                  bloc..add(UkuranBarangTambahEvent(ukuran));
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          ],
                          content: Form(
                            key: _key,
                            child: TextFormField(
                              decoration: InputDecoration(
                                  hintText: "Masukkan Nama Ukuran Barang"),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Ukuran Barang tidak boleh kosong";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                nama = value;
                              },
                            ),
                          ),
                        ));
              },
            )),
      ],
    );
  }
}
