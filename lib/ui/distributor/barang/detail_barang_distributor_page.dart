import 'package:cached_network_image/cached_network_image.dart';
import 'package:division/division.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wholesale/bloc/distributor/barang/distributor_barang_bloc.dart';
import 'package:wholesale/models/distributor_barang_model.dart';
import 'package:wholesale/static_data.dart';

class DetailBarangDistributorPage extends StatelessWidget {
  DistributorBarangModel barang;
  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).unfocus();
    ScreenUtil.init(context,
        designSize: Size(StaticData.screenWidth, StaticData.screenHeight),
        allowFontScaling: true);
    barang = Get.arguments;
    return Scaffold(
        body: BlocProvider(
            create: (context) => DistributorBarangBloc()
              ..add(DistributorBarangGetEvent(barang.id)),
            child: DetailBarangDistributorView()));
  }
}

class DetailBarangDistributorView extends StatelessWidget {
  DistributorBarangModel barang;
  DistributorBarangBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<DistributorBarangBloc>(context);
    return BlocConsumer<DistributorBarangBloc, DistributorBarangState>(
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
      } else if (state is DistributorBarangFormSuccess) {
        Flushbar(
          title: "Error",
          message: state.data['message'] ?? "",
          duration: Duration(seconds: 5),
          icon: Icon(
            Icons.do_not_disturb,
            color: Colors.redAccent,
          ),
          flushbarPosition: FlushbarPosition.TOP,
          onStatusChanged: (status) {
            if (status == FlushbarStatus.DISMISSED) {
              Get.back();
            }
          },
        )..show(Get.context);
      }
    }, builder: (context, state) {
      if (state is DistributorBarangStateSuccess) {
        barang = DistributorBarangModel.createFromJson(state.data['data']);
        return RefreshIndicator(
          onRefresh: () {
            bloc..add(DistributorBarangGetEvent(barang.id));
            return null;
          },
          child: CustomScrollView(slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 250.0,
              floating: true,
              pinned: true,
              snap: true,
              elevation: 5,
              actions: [
                PopupMenuButton<String>(
                  onSelected: (choice) {
                    if (choice == "stok") {
                      Get.toNamed("/distributorstokbarang", arguments: barang);
                    } else if (choice == "ubah") {
                      Get.toNamed("/distributoreditbarang", arguments: barang);
                    } else if (choice == 'hapus') {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text(
                                    "Konfirmasi hapus Barang ${barang.nama_barang}"),
                                content: Text(
                                    "Yakin ingin menghpapus Barang ${barang.nama_barang}"),
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
                                          ..add(DistributorBarangDeleteEvent(
                                              barang.id));
                                      }),
                                ],
                              ));
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return ["stok", "ubah", "hapus"].map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice.capitalizeFirst),
                      );
                    }).toList();
                  },
                )
              ],
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text("${barang.nama_barang}"),
                background: Stack(
                  children: [
                    Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Hero(
                          tag: "hero-${barang.id}",
                          child: CachedNetworkImage(
                            width: 50,
                            height: 50,
                            imageUrl:
                                "${StaticData.baseUrl}/uploads/${barang.foto ?? 'kosong.png'}",
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                new CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                new Icon(Icons.error),
                          ),
                        )),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Parent(
                          gesture: Gestures()
                            ..onTap(() {
                              Get.toNamed("/image_view", arguments: {
                                "url":
                                    "${StaticData.baseUrl}/uploads/${barang.foto ?? 'kosong.png'}",
                                'id': "${barang.id}"
                              });
                            }),
                          child: Container(),
                          style: ParentStyle()
                            ..linearGradient(colors: [
                              Colors.black.withOpacity(0.5),
                              Colors.black.withOpacity(0.5)
                            ])),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate.fixed(<Widget>[
              ListTile(
                title: Text("Jenis Barang"),
                subtitle: Text(barang.jenis_barang_nama),
                tileColor: Colors.white,
              ),
              ListTile(
                title: Text("Ukurang Barang"),
                subtitle: Text(barang.ukuran_barang_nama),
                tileColor: Colors.white,
              ),
              ListTile(
                title: Text("Stok"),
                subtitle: Text(barang.stok.toString()),
                tileColor: Colors.white,
              ),
              ListTile(
                title: Text("Harga Dasar"),
                subtitle: Text(barang.harga_dasar.toString()),
                tileColor: Colors.white,
              ),
              ListTile(
                title: Text("Harga Jual"),
                subtitle: Text(barang.harga_jual.toString()),
                tileColor: Colors.white,
              ),
              ListTile(
                title: Text("Keterangan"),
                subtitle: Text(barang.keterangan.toString()),
                tileColor: Colors.white,
              ),
            ])),
          ]),
        );
      } else if (state is DistributorBarangStateLoading) {
        return Container(
            child: Center(
                child: CircularProgressIndicator(
          backgroundColor: Colors.white,
        )));
      }
      return Container();
    });
  }
}
