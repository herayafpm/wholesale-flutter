import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wholesale/bloc/toko/dashboard/tokodashboard_bloc.dart';
import 'package:wholesale/controllers/home_controller.dart';
import 'package:wholesale/static_data.dart';
import 'package:wholesale/ui/home_page.dart';
import 'package:wholesale/utils/convert_utils.dart';
import 'package:wholesale/utils/greeting_utils.dart';

class DashboardKaryawanController extends GetxController {
  final listIcon = [].obs;
  @override
  void onInit() async {
    listIcon.value = [
      {"title": "Transaksi", "icon": Icons.monetization_on, "onpress": 3},
      {"title": "Barang", "icon": Icons.account_box, "onpress": 2},
      {"title": "Printer", "icon": Icons.print, "onpress": 4},
    ];
    super.onInit();
  }
}

class DashboardKaryawanPage extends StatelessWidget {
  final controller = Get.put(DashboardKaryawanController());
  final homeController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(StaticData.screenWidth, StaticData.screenHeight),
        allowFontScaling: true);
    return Container(
      height: 1.sh,
      width: 1.sw,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            bottom: 0,
            child: Container(
              color: Colors.white,
            ),
          ),
          Parent(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Txt("Selamat " + GreetingUtils.show(),
                      style: TxtStyle()
                        ..fontSize(18.sp)
                        ..textColor(Colors.white)),
                  SizedBox(
                    height: 0.02.sh,
                  ),
                  Txt(homeController.userModel.value.nama.capitalizeFirst ?? "",
                      style: TxtStyle()
                        ..fontSize(18.sp)
                        ..textColor(Colors.white)),
                  SizedBox(
                    height: 0.05.sh,
                  ),
                ],
              ),
              style: ParentStyle()
                ..background
                    .image(path: "assets/images/night.jpg", fit: BoxFit.cover)
                ..height(0.25.sh)
                ..width(1.sw)),
          Positioned(
            top: 0.18.sh,
            left: 0.05.sw,
            right: 0.05.sw,
            child: Parent(
              child: Column(
                children: [
                  BlocProvider(
                    create: (context) =>
                        TokoDashboardBloc()..add(TokoDashboardGetEvent()),
                    child: BlocBuilder<TokoDashboardBloc, TokoDashboardState>(
                      builder: (context, state) {
                        int keuntungan = 0;
                        int aset = 0;
                        if (state is TokoDashboardStateSuccess) {
                          Map<String, dynamic> data = state.data;
                          keuntungan = data['keuntungan'];
                          aset = data['aset'];
                        }
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Txt(
                                  "Keuntungan",
                                  style: TxtStyle()
                                    ..fontSize(14.sp)
                                    ..fontWeight(FontWeight.w500),
                                ),
                                Row(
                                  children: [
                                    Txt("Rp${ConvertUtils.formatMoney(keuntungan)}"),
                                    Icon(Icons.arrow_right_rounded)
                                  ],
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Txt(
                                  "Aset",
                                  style: TxtStyle()
                                    ..fontSize(14.sp)
                                    ..fontWeight(FontWeight.w500),
                                ),
                                Row(
                                  children: [
                                    Txt("Rp${ConvertUtils.formatMoney(aset)}"),
                                    Icon(Icons.arrow_right_rounded)
                                  ],
                                )
                              ],
                            )
                          ],
                        );
                      },
                    ),
                  ),
                  Divider(),
                  Expanded(
                      child: Obx(() => ListView.builder(
                            itemExtent: 90,
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.listIcon.length,
                            itemBuilder: (context, index) => Parent(
                              gesture: Gestures()
                                ..onTap(() {
                                  homeController.actionsList = [];
                                  if (homeController.userModel.value.role_id ==
                                          1 &&
                                      controller.listIcon[index]['title']
                                          .contains('Barang')) {
                                    homeController.updateListBarang();
                                  }
                                  homeController.page.value =
                                      controller.listIcon[index]['onpress'];
                                }),
                              style: ParentStyle()
                                ..ripple(true, splashColor: Colors.blueAccent)
                                ..borderRadius(all: 10),
                              child: Column(
                                children: [
                                  Icon(
                                      controller.listIcon[index]['icon'] ??
                                          Icons.ac_unit,
                                      size: 40.sp,
                                      color: Colors.grey),
                                  Txt(
                                    controller.listIcon[index]['title'] ?? "",
                                    style: TxtStyle()
                                      ..fontSize(14.sp)
                                      ..textColor(Colors.grey),
                                  )
                                ],
                              ),
                            ),
                          )))
                ],
              ),
              style: ParentStyle()
                ..height(0.2.sh)
                ..padding(all: 10)
                ..background.color(Colors.white)
                ..borderRadius(all: 20)
                ..elevation(3),
            ),
          ),
        ],
      ),
    );
  }
}
