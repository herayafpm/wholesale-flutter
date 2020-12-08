import 'package:division/division.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:wholesale/bloc/toko/barang/toko_barang_bloc.dart';
import 'package:wholesale/models/toko_barang_model.dart';
import 'package:wholesale/static_data.dart';
import 'package:wholesale/ui/components/item_button_process.dart';
import 'package:wholesale/ui/components/item_input_text.dart';

class EditBarangTokoController extends GetxController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController hargaJualController = TextEditingController();
  TextEditingController keteranganController = TextEditingController();
  final isLoading = false.obs;
  final barang = TokoBarangModel().obs;
  void process(TokoBarangBloc bloc) {
    isLoading.value = true;
    barang.update((val) {
      val.harga_jual = int.parse(hargaJualController.text);
      val.keterangan = keteranganController.text;
    });
    bloc..add(TokoBarangEditEvent(barang.value));
  }

  @override
  void onInit() {
    barang.value = Get.arguments;
    hargaJualController.text = barang.value.harga_jual.toString();
    keteranganController.text = barang.value.keterangan;
    super.onInit();
  }
}

class EditBarangTokoPage extends StatelessWidget {
  final controller = Get.put(EditBarangTokoController());
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(StaticData.screenWidth, StaticData.screenHeight),
        allowFontScaling: true);
    return Scaffold(
        appBar: AppBar(
            title: Text(
                "Edit Barang Toko ${controller.barang.value.nama_barang}")),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocProvider(
            create: (context) => TokoBarangBloc(),
            child: EditBarangTokoView(),
          ),
        ));
  }
}

class EditBarangTokoView extends StatelessWidget {
  final controller = Get.find<EditBarangTokoController>();
  TokoBarangBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<TokoBarangBloc>(context);
    return BlocListener<TokoBarangBloc, TokoBarangState>(
      listener: (context, state) {
        if (state is TokoBarangStateError) {
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
        } else if (state is TokoBarangFormSuccess) {
          controller.isLoading.value = false;
          Get.back();
          Flushbar(
              title: "Success",
              message: state.data['message'] ?? "",
              duration: Duration(seconds: 5),
              icon: Icon(
                Icons.check,
                color: Colors.greenAccent,
              ),
              flushbarPosition: FlushbarPosition.TOP)
            ..show(Get.context);
        }
      },
      child: Form(
        key: controller.formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Txt("Harga Jual",
                      style: TxtStyle()
                        ..fontSize(16.ssp)
                        ..textColor(Colors.white)),
                  SizedBox(
                    height: 0.01.sh,
                  ),
                  ItemInputText(
                    tipe: TextInputType.number,
                    hint: "Harga Jual",
                    controller: controller.hargaJualController,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "Masukkan Harga Jual";
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
                    tipe: TextInputType.text,
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
                ],
              ),
            ),
            Obx(
              () => ItemButtonProcess(
                  title: "Kirim Data",
                  isLoading: controller.isLoading.value,
                  onTap: () {
                    if (controller.formKey.currentState.validate()) {
                      controller.process(bloc);
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
