import 'package:division/division.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wholesale/bloc/auth/authbloc.dart';
import 'package:wholesale/models/user_model.dart';
import 'package:wholesale/static_data.dart';
import 'package:wholesale/ui/components/item_button_process.dart';
import 'package:wholesale/ui/components/item_input_text.dart';

class ProfileEditPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(StaticData.screenWidth, StaticData.screenHeight),
        allowFontScaling: true);
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
      ),
      body: BlocProvider(
        create: (context) => AuthBloc()..add(AuthBlocGetProfileEvent()),
        child: ProfileEditView(),
      ),
    );
  }
}

class ProfileEditViewController extends GetxController {
  TextEditingController usernameController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController noTelpController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final isLoading = false.obs;
  final user = UserModel().obs;

  void updateProfile(AuthBloc bloc) {
    isLoading.value = !isLoading.value;
    user.value.username = usernameController.text;
    user.value.nama = namaController.text;
    user.value.email = emailController.text;
    user.value.alamat = alamatController.text;
    user.value.no_telp = noTelpController.text;
    bloc..add(AuthBlocUpdateProfileEvent(user.value));
  }
}

class ProfileEditView extends StatelessWidget {
  final controller = Get.put(ProfileEditViewController());
  AuthBloc bloc;
  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<AuthBloc>(context);
    return BlocConsumer<AuthBloc, AuthBlocState>(
      listener: (context, state) {
        if (state is AuthBlocFormSuccess) {
          controller.isLoading.value = false;
          print("data ${state.data}");
          bloc..add(AuthBlocGetProfileEvent());
        } else if (state is AuthBlocStateError) {
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
        } else if (state is AuthBlocStateSuccess) {
          controller.isLoading.value = false;
          UserModel user = UserModel.createFromJson(state.data['data']);
          controller.user.value = user;
          controller.usernameController.text = user.username;
          controller.namaController.text = user.nama;
          controller.emailController.text = user.email;
          controller.alamatController.text = user.alamat;
          controller.noTelpController.text = user.no_telp;
        }
      },
      builder: (context, state) {
        if (state is AuthBlocStateLoading) {
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
            bloc..add(AuthBlocGetProfileEvent());
            return null;
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: controller.formKey,
              child: ListView(
                children: [
                  Txt("Nama Lengkap",
                      style: TxtStyle()
                        ..fontSize(16.ssp)
                        ..textColor(Colors.white)),
                  SizedBox(
                    height: 0.01.sh,
                  ),
                  ItemInputText(
                    hint: "Nama",
                    controller: controller.namaController,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "Masukkan Nama";
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
                            controller.updateProfile(bloc);
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
