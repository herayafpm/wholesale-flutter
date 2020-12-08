import 'package:cached_network_image/cached_network_image.dart';
import 'package:division/division.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wholesale/bloc/toko/barang/toko_barang_bloc.dart';
import 'package:wholesale/controllers/home_controller.dart';
import 'package:wholesale/models/toko_barang_model.dart';
import 'package:wholesale/static_data.dart';
import 'package:wholesale/ui/home_page.dart';
import 'package:wholesale/utils/convert_utils.dart';
import 'package:wholesale/utils/role_utils.dart';

class DetailBarangTokoPage extends StatelessWidget {
  TokoBarangModel barang;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(StaticData.screenWidth, StaticData.screenHeight),
        allowFontScaling: true);
    barang = Get.arguments;
    return Scaffold(
        body: BlocProvider(
            create: (context) =>
                TokoBarangBloc()..add(TokoBarangGetEvent(barang.id)),
            child: DetailBarangTokoView()));
  }
}

class DetailBarangTokoView extends StatelessWidget {
  final homeController = Get.find<HomeController>();
  TokoBarangModel barang;
  TokoBarangBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<TokoBarangBloc>(context);
    return BlocConsumer<TokoBarangBloc, TokoBarangState>(
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
      } else if (state is TokoBarangFormSuccess) {
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
      if (state is TokoBarangStateSuccess) {
        barang = TokoBarangModel.createFromJson(state.data['data']);
        return RefreshIndicator(
          onRefresh: () {
            bloc..add(TokoBarangGetEvent(barang.id));
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
                (RoleUtils.isPemilikToko(homeController.role.value))
                    ? IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Get.toNamed("editbarangtoko", arguments: barang);
                        },
                      )
                    : Container(),
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
                subtitle: Text("${ConvertUtils.formatMoney(barang.stok)}"),
                tileColor: Colors.white,
              ),
              ListTile(
                title: Text("Harga Dasar"),
                subtitle:
                    Text("Rp${ConvertUtils.formatMoney(barang.harga_dasar)}"),
                tileColor: Colors.white,
              ),
              ListTile(
                title: Text("Harga Jual"),
                subtitle:
                    Text("Rp${ConvertUtils.formatMoney(barang.harga_jual)}"),
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
      } else if (state is TokoBarangStateLoading) {
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
