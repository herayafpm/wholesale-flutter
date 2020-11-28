import 'package:division/division.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:wholesale/bloc/toko/karyawan/karyawan_bloc.dart';
import 'package:wholesale/models/karyawan_model.dart';
import 'package:wholesale/static_data.dart';
import 'package:wholesale/ui/components/item_button_process.dart';
import 'package:wholesale/ui/components/item_input_text.dart';

class TambahKaryawanController extends GetxController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController noTelpController = TextEditingController();
  final isLoading = false.obs;
  void process(KaryawanBloc bloc) {
    isLoading.value = true;
    KaryawanModel karyawan = KaryawanModel(
        username: usernameController.text,
        nama: namaController.text,
        email: emailController.text,
        alamat: alamatController.text,
        no_telp: noTelpController.text);
    bloc..add(KaryawanTambahEvent(karyawan));
  }
}

class TambahKaryawanPage extends StatelessWidget {
  final controller = Get.put(TambahKaryawanController());
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(StaticData.screenWidth, StaticData.screenHeight),
        allowFontScaling: true);
    return Scaffold(
        appBar: AppBar(
          title: Text("Tambah Karyawan"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocProvider(
            create: (context) => KaryawanBloc(),
            child: TambahKaryawanView(),
          ),
        ));
  }
}

class TambahKaryawanView extends StatelessWidget {
  final controller = Get.find<TambahKaryawanController>();
  KaryawanBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<KaryawanBloc>(context);
    return BlocListener<KaryawanBloc, KaryawanState>(
      listener: (context, state) {
        if (state is KaryawanStateSuccess) {
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
        } else if (state is KaryawanStateError) {
          controller.isLoading.value = false;
          Flushbar(
            title: "Error",
            message: state.errors['data']['username'] ??
                state.errors['data']['email'] ??
                state.errors['message'] ??
                "",
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
            Txt("Username",
                style: TxtStyle()
                  ..fontSize(16.ssp)
                  ..textColor(Colors.white)),
            SizedBox(
              height: 0.01.sh,
            ),
            ItemInputText(
              hint: "Username",
              controller: controller.usernameController,
              validator: (String value) {
                if (value.isEmpty) {
                  return "Masukkan Username";
                }
                return null;
              },
            ),
            Txt("Nama Karyawan",
                style: TxtStyle()
                  ..fontSize(16.ssp)
                  ..textColor(Colors.white)),
            SizedBox(
              height: 0.01.sh,
            ),
            ItemInputText(
              hint: "Nama Karyawan",
              controller: controller.namaController,
              validator: (String value) {
                if (value.isEmpty) {
                  return "Masukkan Nama Karyawan";
                }
                return null;
              },
            ),
            SizedBox(
              height: 0.02.sh,
            ),
            Txt("Email",
                style: TxtStyle()
                  ..fontSize(16.ssp)
                  ..textColor(Colors.white)),
            SizedBox(
              height: 0.01.sh,
            ),
            ItemInputText(
              tipe: TextInputType.emailAddress,
              hint: "Email",
              controller: controller.emailController,
              validator: (String value) {
                if (value.isEmpty) {
                  return "Masukkan Email";
                }
                return null;
              },
            ),
            SizedBox(
              height: 0.02.sh,
            ),
            Txt("Alamat",
                style: TxtStyle()
                  ..fontSize(16.ssp)
                  ..textColor(Colors.white)),
            SizedBox(
              height: 0.01.sh,
            ),
            ItemInputText(
              hint: "Alamat",
              controller: controller.alamatController,
              validator: (String value) {
                if (value.isEmpty) {
                  return "Masukkan Alamat";
                }
                return null;
              },
            ),
            SizedBox(
              height: 0.02.sh,
            ),
            Txt("No Telp",
                style: TxtStyle()
                  ..fontSize(16.ssp)
                  ..textColor(Colors.white)),
            SizedBox(
              height: 0.01.sh,
            ),
            ItemInputText(
              tipe: TextInputType.number,
              hint: "No Telp",
              controller: controller.noTelpController,
              validator: (String value) {
                if (value.isEmpty) {
                  return "Masukkan No Telp";
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
