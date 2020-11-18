import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wholesale/bloc/auth/authbloc.dart';
import 'package:wholesale/bloc/toko/toko_bloc.dart';
import 'package:wholesale/models/toko_model.dart';
import 'package:wholesale/static_data.dart';

class ProfileTokoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(StaticData.screenWidth, StaticData.screenHeight),
        allowFontScaling: true);
    return Stack(
      children: [
        BlocProvider(
          create: (context) => TokoBloc()..add(TokoGetEvent()),
          child: ProfileTokoPageView(),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            splashColor: Colors.white,
            child: Icon(Icons.edit),
            onPressed: () {
              Get.toNamed("/editprofiletoko");
            },
          ),
        ),
      ],
    );
  }
}

class ProfileTokoPageView extends StatelessWidget {
  TokoBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<TokoBloc>(context);
    return BlocConsumer<TokoBloc, TokoState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is TokoStateSuccess) {
          TokoModel user = TokoModel.createFromJson(state.data['data']);
          return RefreshIndicator(
            onRefresh: () {
              bloc..add(TokoGetEvent());
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
                        Icons.storefront,
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
        } else if (state is TokoStateLoading) {
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
