import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wholesale/bloc/distributor/barang/stok/distributor_barang_stok_bloc.dart';
import 'package:wholesale/models/distributor_barang_model.dart';
import 'package:wholesale/models/distributor_barang_stok_model.dart';
import 'package:wholesale/static_data.dart';

class ManajemenStokBarangDistributorController extends GetxController {
  final obj = ''.obs;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController stokController = TextEditingController();
  TextEditingController keteranganController = TextEditingController();
  final isLoading = false.obs;
  final stok = DistributorBarangStokModel().obs;
  void process(int id, DistributorBarangStokBloc bloc) {
    isLoading.value = true;
    stok.update((val) {
      val.stok_perubahan = int.parse(stokController.text);
      val.keterangan = keteranganController.text;
    });
    bloc..add(DistributorBarangStokTambahEvent(id, stok.value));
  }
}

class ManajemenStokBarangDistributorPage extends StatelessWidget {
  final controller = Get.put(ManajemenStokBarangDistributorController());
  DistributorBarangModel barang;
  @override
  Widget build(BuildContext context) {
    barang = Get.arguments;
    ScreenUtil.init(context,
        designSize: Size(StaticData.screenWidth, StaticData.screenHeight),
        allowFontScaling: true);
    return BlocProvider(
      create: (context) => DistributorBarangStokBloc()
        ..add(DistributorBarangStokGetListEvent(barang.id)),
      child: Scaffold(
          appBar: AppBar(
            title: Text("Riwayat Stok ${barang.nama_barang}"),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Get.toNamed("/distributortambahstokbarang",
                  arguments: Get.arguments);
            },
          ),
          body: ManajemenStokBarangDistributorView(
            barang: barang,
          )),
    );
  }
}

class ManajemenStokBarangDistributorView extends StatelessWidget {
  final DistributorBarangModel barang;
  DistributorBarangStokBloc bloc;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  ManajemenStokBarangDistributorView({Key key, this.barang}) : super(key: key);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    bloc..add(DistributorBarangStokGetListEvent(barang.id, refresh: true));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    bloc..add(DistributorBarangStokGetListEvent(barang.id));
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<DistributorBarangStokBloc>(context);
    return Container(
      color: Colors.white,
      child:
          BlocConsumer<DistributorBarangStokBloc, DistributorBarangStokState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          if (state is DistributorBarangStokListLoaded) {
            if (state.stoks != null && state.stoks.length > 0) {
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
                    itemCount: state.stoks.length,
                    itemBuilder: (BuildContext context, int index) {
                      DistributorBarangStokModel stok = state.stoks[index];
                      return ListTile(
                          tileColor: Colors.white,
                          title: Text(stok.keterangan),
                          subtitle: Text(
                              "Stok Terakhir ${stok.stok_sekarang}, Stok Perubahan ${stok.stok_perubahan}, Stok Sekarang ${stok.stok_sekarang + stok.stok_perubahan}"));
                    },
                  ));
            }
          }
          return Container(
            child: Center(
              child: Text("Belum ada riwayat"),
            ),
          );
        },
      ),
    );
  }
}
