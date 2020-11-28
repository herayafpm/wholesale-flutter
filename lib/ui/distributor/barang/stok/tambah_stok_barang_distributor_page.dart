import 'package:division/division.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:wholesale/bloc/distributor/barang/stok/distributor_barang_stok_bloc.dart';
import 'package:wholesale/models/distributor_barang_model.dart';
import 'package:wholesale/models/distributor_barang_stok_model.dart';
import 'package:wholesale/static_data.dart';
import 'package:wholesale/ui/components/item_button_process.dart';
import 'package:wholesale/ui/components/item_input_text.dart';

class TambahStokBarangDistributorController extends GetxController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController stokController = TextEditingController();
  TextEditingController keteranganController = TextEditingController();
  final barang = DistributorBarangModel().obs;
  final isLoading = false.obs;
  void process(DistributorBarangStokBloc bloc) {
    isLoading.value = true;
    DistributorBarangStokModel stok = DistributorBarangStokModel(
      keterangan: keteranganController.text,
      stok_perubahan: int.parse(stokController.text),
    );
    bloc..add(DistributorBarangStokTambahEvent(barang.value.id, stok));
  }
}

class TambahStokBarangDistributorPage extends StatelessWidget {
  final controller = Get.put(TambahStokBarangDistributorController());
  @override
  Widget build(BuildContext context) {
    controller.barang.value = Get.arguments;
    ScreenUtil.init(context,
        designSize: Size(StaticData.screenWidth, StaticData.screenHeight),
        allowFontScaling: true);
    return Scaffold(
        appBar: AppBar(
          title:
              Text("Tambah Stok Barang ${controller.barang.value.nama_barang}"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocProvider(
            create: (context) => DistributorBarangStokBloc(),
            child: TambahStokBarangDistributorView(),
          ),
        ));
  }
}

class TambahStokBarangDistributorView extends StatelessWidget {
  final controller = Get.find<TambahStokBarangDistributorController>();
  DistributorBarangStokBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<DistributorBarangStokBloc>(context);
    return BlocListener<DistributorBarangStokBloc, DistributorBarangStokState>(
      listener: (context, state) {
        if (state is DistributorBarangStokStateSuccess) {
          controller.isLoading.value = false;
          Flushbar(
            title: "Success",
            message: state.data['message'],
            icon: Icon(
              Icons.check,
              color: Colors.greenAccent,
            ),
            duration: Duration(seconds: 2),
            onStatusChanged: (FlushbarStatus status) {
              if (status == FlushbarStatus.DISMISSED) {
                Get.back();
              }
            },
          )..show(context);
        } else if (state is DistributorBarangStokStateError) {
          controller.isLoading.value = false;
          Flushbar(
            title: "Error",
            message: state.errors['message'] ?? "",
            duration: Duration(seconds: 5),
            icon: Icon(
              Icons.do_not_disturb,
              color: Colors.redAccent,
            ),
          )..show(Get.context);
        }
      },
      child: Form(
        key: controller.formKey,
        child: ListView(
          children: [
            Txt("Stok",
                style: TxtStyle()
                  ..fontSize(16.ssp)
                  ..textColor(Colors.white)),
            SizedBox(
              height: 0.01.sh,
            ),
            ItemInputText(
              tipe: TextInputType.number,
              hint: "Stok",
              controller: controller.stokController,
              validator: (String value) {
                if (value.isEmpty) {
                  return "Masukkan Stok";
                }
                return null;
              },
            ),
            SizedBox(
              height: 0.02.sh,
            ),
            Txt("Keterangan",
                style: TxtStyle()
                  ..fontSize(16.ssp)
                  ..textColor(Colors.white)),
            SizedBox(
              height: 0.01.sh,
            ),
            ItemInputText(
              hint: "Keterangan",
              controller: controller.keteranganController,
              validator: (String value) {
                if (value.isEmpty) {
                  return "Masukkan Keterangan";
                }
                return null;
              },
            ),
            SizedBox(
              height: 0.02.sh,
            ),
            Obx(() => ItemButtonProcess(
                  title: "Kirim Data",
                  isLoading: controller.isLoading.value,
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    if (controller.formKey.currentState.validate()) {
                      controller.process(bloc);
                    }
                  },
                ))
          ],
        ),
      ),
    );
  }
}
