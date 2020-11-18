import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wholesale/bloc/auth/authbloc.dart';

class ForgotPassController extends GetxController {
  final username = ''.obs;
  final password = ''.obs;
  final password2 = ''.obs;
  final isShowPass = false.obs;
  final isLoading = false.obs;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void forgotpass(AuthBloc bloc) async {
    isLoading.value = !isLoading.value;
    username.value = usernameController.text;
    password.value = passwordController.text;
    bloc..add(AuthBlocForgotPassEvent(username.value, password.value));
  }
}
