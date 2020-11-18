import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wholesale/bloc/auth/authbloc.dart';
import 'package:wholesale/models/user_model.dart';
import 'package:wholesale/static_data.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(StaticData.screenWidth, StaticData.screenHeight),
        allowFontScaling: true);
    return Stack(
      children: [
        BlocProvider(
          create: (context) => AuthBloc()..add(AuthBlocGetProfileEvent()),
          child: ProfilePageView(),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            splashColor: Colors.white,
            child: Icon(Icons.edit),
            onPressed: () {
              Get.toNamed("/editprofile");
            },
          ),
        ),
      ],
    );
  }
}

class ProfilePageView extends StatelessWidget {
  AuthBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<AuthBloc>(context);
    return BlocConsumer<AuthBloc, AuthBlocState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is AuthBlocStateSuccess) {
          UserModel user = UserModel.createFromJson(state.data['data']);
          return RefreshIndicator(
            onRefresh: () {
              bloc..add(AuthBlocGetProfileEvent());
              return null;
            },
            child: Column(
              children: [
                Flexible(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_box,
                        color: Colors.white,
                        size: 50.ssp,
                      ),
                      Txt(
                        user.nama ?? "",
                        style: TxtStyle()
                          ..fontSize(18.ssp)
                          ..textColor(Colors.white),
                      ),
                    ],
                  ),
                ),
                Flexible(
                    flex: 2,
                    child: ListView(
                      children: [
                        ListTile(
                          leading: Icon(Icons.mail),
                          tileColor: Colors.white,
                          title: Txt("Email"),
                          subtitle: Txt(user.email ?? ""),
                        ),
                        ListTile(
                          leading: Icon(Icons.pin_drop),
                          tileColor: Colors.white,
                          title: Txt("Alamat"),
                          subtitle: Txt(user.alamat ?? ""),
                        ),
                        ListTile(
                          leading: Icon(Icons.call),
                          tileColor: Colors.white,
                          title: Txt("Telepon"),
                          subtitle: Txt(user.no_telp ?? ""),
                        ),
                      ],
                    )),
              ],
            ),
          );
        } else if (state is AuthBlocStateLoading) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
