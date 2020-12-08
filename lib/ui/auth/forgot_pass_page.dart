import 'dart:async';

import 'package:division/division.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:wholesale/bloc/auth/authbloc.dart';
import 'package:wholesale/controllers/forgot_pass_controller.dart';
import 'package:wholesale/static_data.dart';
import 'package:wholesale/ui/components/item_button_process.dart';
import 'package:wholesale/ui/components/item_input_text.dart';

// ignore: must_be_immutable
class ForgotPassPage extends GetView<ForgotPassController> {
  final controller = Get.put(ForgotPassController());
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(StaticData.screenWidth, StaticData.screenHeight),
        allowFontScaling: true);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocProvider(
            create: (context) => AuthBloc(), child: FormForgotPassView()));
  }
}

// ignore: must_be_immutable
class FormForgotPassView extends StatelessWidget {
  final controller = Get.find<ForgotPassController>();
  // ignore: close_sinks
  AuthBloc bloc;
  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<AuthBloc>(context);
    return BlocListener<AuthBloc, AuthBlocState>(
      listener: (context, state) {
        if (state is AuthBlocStateLoading) {
          controller.isLoading.value = true;
        } else if (state is AuthBlocStateSuccess) {
          controller.isLoading.value = false;
          Flushbar(
            title: "Success",
            message: state.data['message'] ?? "",
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
            flushbarPosition: FlushbarPosition.TOP,
          )..show(context);
        } else if (state is AuthBlocStateError) {
          controller.isLoading.value = false;
          Flushbar(
            title: "Error",
            message: state.errors['data']['username'] ??
                state.errors['data']['message'] ??
                "",
            duration: Duration(seconds: 5),
            icon: Icon(
              Icons.do_not_disturb,
              color: Colors.redAccent,
            ),
            flushbarPosition: FlushbarPosition.TOP,
          )..show(Get.context);
        }
      },
      child: Parent(
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_box,
                  size: 0.15.sw,
                  color: Colors.white,
                ),
                SizedBox(
                  height: 0.01.sh,
                ),
                Txt("Lupa Password",
                    style: TxtStyle()
                      ..textColor(Colors.white)
                      ..fontSize(16.ssp)
                      ..fontWeight(FontWeight.w500)),
                SizedBox(
                  height: 0.02.sh,
                ),
                ItemInputText(
                  hint: "Username",
                  controller: controller.usernameController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Username tidak boleh kosong";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 0.02.sh,
                ),
                Obx(() => ItemInputText(
                      hint: "Password",
                      isSecure: true,
                      changeObsecure: () {
                        controller.isShowPass.value =
                            !controller.isShowPass.value;
                      },
                      obsecure: controller.isShowPass.value,
                      controller: controller.passwordController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Password tidak boleh kosong";
                        }
                        if (value.length < 6) {
                          return "Password harus lebih dari 6 karakter";
                        }
                        if (value != controller.password2Controller.text) {
                          return "Password harus sama";
                        }
                        return null;
                      },
                    )),
                SizedBox(
                  height: 0.02.sh,
                ),
                Obx(() => ItemInputText(
                      hint: "Konfirimasi Password",
                      isSecure: true,
                      changeObsecure: () {
                        controller.isShowPass.value =
                            !controller.isShowPass.value;
                      },
                      obsecure: controller.isShowPass.value,
                      controller: controller.password2Controller,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Password tidak boleh kosong";
                        }
                        if (value.length < 6) {
                          return "Password harus lebih dari 6 karakter";
                        }
                        if (value != controller.passwordController.text) {
                          return "Password harus sama";
                        }
                        return null;
                      },
                    )),
                SizedBox(
                  height: 0.02.sh,
                ),
                Parent(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Txt(
                            "Sudah ingat password?",
                            style: TxtStyle()..textColor(Colors.white),
                          ),
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: Txt(
                              "Masuk",
                              style: TxtStyle()..textColor(Colors.white),
                            ),
                          )
                        ]),
                    style: ParentStyle()
                      ..width(1.sw)
                      ..alignmentContent.centerRight()),
                SizedBox(
                  height: 0.02.sh,
                ),
                Obx(() => ItemButtonProcess(
                      title: "Kirim Data",
                      isLoading: controller.isLoading.value,
                      onTap: () {
                        if (controller.formKey.currentState.validate()) {
                          controller.forgotpass(bloc);
                        }
                      },
                    )),
              ],
            ),
          ),
          style: ParentStyle()
            ..width(1.sw)
            ..height(1.sh)
            ..padding(vertical: 0.05.sh, horizontal: 0.05.sw)),
    );
  }
}
