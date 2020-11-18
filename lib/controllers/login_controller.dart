import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wholesale/bloc/auth/authbloc.dart';

class LoginController extends GetxController {
  final username = ''.obs;
  final password = ''.obs;
  final isShowPass = false.obs;
  final isLoading = false.obs;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void login(AuthBloc bloc) async {
    isLoading.value = !isLoading.value;
    username.value = usernameController.text;
    password.value = passwordController.text;
    bloc..add(AuthBlocLoginEvent(username.value, password.value));
  }
}
