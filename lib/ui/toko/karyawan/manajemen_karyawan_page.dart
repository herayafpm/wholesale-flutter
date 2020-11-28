import 'package:division/division.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wholesale/bloc/toko/karyawan/karyawan_bloc.dart';
import 'package:wholesale/models/karyawan_model.dart';
import 'package:wholesale/static_data.dart';

class ManajemenKaryawanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(StaticData.screenWidth, StaticData.screenHeight),
        allowFontScaling: true);
    return Stack(
      children: [
        BlocProvider<KaryawanBloc>(
          create: (context) => KaryawanBloc()..add(KaryawanGetListEvent()),
          child: ManajemenKaryawanView(),
        ),
        Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Get.toNamed("/tambahkaryawan");
              },
            )),
      ],
    );
  }
}

class ManajemenKaryawanView extends StatelessWidget {
  KaryawanBloc bloc;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    bloc..add(KaryawanGetListEvent(refresh: true));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    bloc..add(KaryawanGetListEvent());
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<KaryawanBloc>(context);
    return BlocConsumer<KaryawanBloc, KaryawanState>(
      listener: (context, state) {
        if (state is KaryawanStateError) {
          Flushbar(
            title: "Error",
            message: state.errors ?? "",
            duration: Duration(seconds: 5),
            icon: Icon(
              Icons.do_not_disturb,
              color: Colors.redAccent,
            ),
            flushbarPosition: FlushbarPosition.TOP,
          )..show(Get.context);
        } else if (state is KaryawanStateSuccess) {
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
        if (state is KaryawanListLoaded) {
          KaryawanListLoaded stateData = state;
          if (stateData.karyawans != null && stateData.karyawans.length > 0) {
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
                itemCount: stateData.karyawans.length,
                itemBuilder: (BuildContext context, int index) {
                  KaryawanModel karyawan = stateData.karyawans[index];
                  return ListTile(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text("Detail Karyawan ${karyawan.nama}"),
                                content: Container(
                                  width: 0.8.sw,
                                  child: RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text: "Email \t ${karyawan.email}\n",
                                          style:
                                              TextStyle(color: Colors.black)),
                                      TextSpan(
                                          text:
                                              "Alamat \t ${karyawan.alamat}\n",
                                          style:
                                              TextStyle(color: Colors.black)),
                                      TextSpan(
                                          text:
                                              "No Telp Karyawan \t ${karyawan.no_telp ?? ""}\n",
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ]),
                                  ),
                                ),
                              ));
                    },
                    trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text(
                                        "Konfirmasi hapus Karyawan ${karyawan.nama}"),
                                    content: Text(
                                        "Yakin ingin menghpapus Karyawan ${karyawan.nama}"),
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
                                              ..add(KaryawanDeleteEvent(
                                                  karyawan.id));
                                          }),
                                    ],
                                  ));
                        }),
                    tileColor: Colors.white,
                    title: Txt(karyawan.nama),
                  );
                },
              ),
            );
          } else {
            return Container(
              child: Center(
                  child: Txt(
                "Anda Belum Pernah Melakukan Penambahan Karyawan",
                style: TxtStyle()
                  ..fontSize(16.sp)
                  ..textColor(Colors.white)
                  ..textAlign.center(),
              )),
            );
          }
        }
        return Container(
          child: Center(
            child: Text("Anda belum menambahkan karyawan"),
          ),
        );
      },
    );
  }
}
