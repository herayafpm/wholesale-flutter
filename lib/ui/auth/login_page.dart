import 'package:division/division.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:wholesale/bloc/auth/authbloc.dart';
import 'package:wholesale/controllers/login_controller.dart';
import 'package:wholesale/models/user_model.dart';
import 'package:wholesale/static_data.dart';
import 'package:wholesale/ui/components/item_button_process.dart';
import 'package:wholesale/ui/components/item_input_text.dart';

class LoginPage extends GetView<LoginController> {
  final controller = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(StaticData.screenWidth, StaticData.screenHeight),
        allowFontScaling: true);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocProvider(
            create: (context) => AuthBloc(), child: FormLoginView()));
  }
}

// ignore: must_be_immutable
class FormLoginView extends StatelessWidget {
  final controller = Get.find<LoginController>();
  // ignore: close_sinks
  AuthBloc authBloc;
  @override
  Widget build(BuildContext context) {
    authBloc = BlocProvider.of<AuthBloc>(context);
    return BlocListener<AuthBloc, AuthBlocState>(
      listener: (context, state) async {
        if (state is AuthBlocStateLoading) {
          controller.isLoading.value = true;
        } else if (state is AuthBlocStateSuccess) {
          controller.isLoading.value = false;
          Flushbar(
            title: "Success",
            message: state.data['message'],
            icon: Icon(
              Icons.check,
              color: Colors.greenAccent,
            ),
            duration: Duration(seconds: 2),
            flushbarPosition: FlushbarPosition.TOP,
          )..show(context);
          var boxUser = await Hive.openBox("user_model");
          var userModel = UserModel.createFromJson(state.data['data']);
          boxUser.add(userModel);
          Get.offAllNamed("/home");
        } else if (state is AuthBlocStateError) {
          controller.isLoading.value = false;
          Flushbar(
            title: "Error",
            message: state.errors['message'],
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
                Txt("Login",
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
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "Masukkan Username";
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
                        return null;
                      },
                    )),
                SizedBox(
                  height: 0.02.sh,
                ),
                Parent(
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: "Lupa Password?",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Get.toNamed("/forgotpass"))
                      ]),
                    ),
                    style: ParentStyle()
                      ..width(1.sw)
                      ..alignmentContent.centerRight()),
                SizedBox(
                  height: 0.02.sh,
                ),
                Obx(() => ItemButtonProcess(
                      title: "Login",
                      isLoading: controller.isLoading.value,
                      onTap: () {
                        if (controller.formKey.currentState.validate()) {
                          controller.login(authBloc);
                        }
                      },
                    ))
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
