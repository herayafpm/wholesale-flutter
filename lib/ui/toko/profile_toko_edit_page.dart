import 'package:division/division.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wholesale/bloc/toko/toko_bloc.dart';
import 'package:wholesale/models/toko_model.dart';
import 'package:wholesale/static_data.dart';
import 'package:wholesale/ui/components/item_button_process.dart';
import 'package:wholesale/ui/components/item_input_text.dart';

class ProfileTokoEditPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(StaticData.screenWidth, StaticData.screenHeight),
        allowFontScaling: true);
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile Toko"),
      ),
      body: BlocProvider(
        create: (context) => TokoBloc()..add(TokoGetEvent()),
        child: ProfileTokoEditView(),
      ),
    );
  }
}

class ProfileTokoEditViewController extends GetxController {
  TextEditingController usernameController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController noTelpController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final isLoading = false.obs;
  final toko = TokoModel().obs;

  void updateToko(TokoBloc bloc) {
    isLoading.value = !isLoading.value;
    toko.value.nama = namaController.text;
    toko.value.email = emailController.text;
    toko.value.alamat = alamatController.text;
    toko.value.no_telp = noTelpController.text;
    bloc..add(TokoUpdateEvent(toko.value));
  }
}

class ProfileTokoEditView extends StatelessWidget {
  final controller = Get.put(ProfileTokoEditViewController());
  TokoBloc bloc;
  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<TokoBloc>(context);
    return BlocConsumer<TokoBloc, TokoState>(
      listener: (context, state) {
        if (state is TokoFormSuccess) {
          controller.isLoading.value = false;
          Flushbar(
            title: "Success",
            message: state.data['message'] ?? "",
            duration: Duration(seconds: 5),
            icon: Icon(
              Icons.check,
              color: Colors.greenAccent,
            ),
          )..show(Get.context);
          bloc..add(TokoGetEvent());
        } else if (state is TokoStateError) {
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
        } else if (state is TokoStateSuccess) {
          controller.isLoading.value = false;
          TokoModel toko = TokoModel.createFromJson(state.data['data']);
          controller.toko.value = toko;
          controller.namaController.text = toko.nama;
          controller.emailController.text = toko.email;
          controller.alamatController.text = toko.alamat;
          controller.noTelpController.text = toko.no_telp;
        }
      },
      builder: (context, state) {
        if (state is TokoStateLoading) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () {
            bloc..add(TokoGetEvent());
            return null;
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: controller.formKey,
              child: ListView(
                children: [
                  Txt("Nama Toko",
                      style: TxtStyle()
                        ..fontSize(16.ssp)
                        ..textColor(Colors.white)),
                  SizedBox(
                    height: 0.01.sh,
                  ),
                  ItemInputText(
                    hint: "Nama Toko",
                    controller: controller.namaController,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "Masukkan Nama Toko";
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
                          if (controller.formKey.currentState.validate()) {
                            controller.updateToko(bloc);
                          }
                        },
                      ))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
