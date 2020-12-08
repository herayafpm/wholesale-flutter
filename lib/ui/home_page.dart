import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:wholesale/controllers/home_controller.dart';
import 'package:wholesale/static_data.dart';

class HomePage extends GetView<HomeController> {
  final controller = Get.put(HomeController());
  DateTime currentBackPressTime;
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 3)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Ketuk 2 kali untuk keluar");
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    ScreenUtil.init(context,
        designSize: Size(StaticData.screenWidth, StaticData.screenHeight),
        allowFontScaling: true);
    return WillPopScope(
      onWillPop: onWillPop,
      child: GetX<HomeController>(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: Txt(_.listDrawer[_.page.value]['title'] ?? ""),
            actions: _.actionsList,
          ),
          body: Obx(() => _.listPage[_.page.value]),
          drawer: Drawer(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.account_box, color: Colors.white, size: 50.sp),
                      SizedBox(
                        height: 0.01.sh,
                      ),
                      Obx(() => Txt(
                            controller.userModel.value.nama.capitalizeFirst,
                            style: TxtStyle()
                              ..textColor(Colors.white)
                              ..fontSize(16.sp),
                          ))
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFF018577),
                  ),
                ),
                Obx(() => Column(
                    children: controller.listDrawer
                        .asMap()
                        .map((index, value) => MapEntry(index, Obx(() {
                              return ListTile(
                                selected: index == controller.page.value,
                                leading: value['icon'],
                                title: Text(value['title']),
                                onTap: () {
                                  controller.page.value = index;
                                  Navigator.pop(context);
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                  controller.actionsList = [];
                                  if (controller.userModel.value.role_id == 1 &&
                                      value['title'].contains('Barang')) {
                                    controller.updateListBarang();
                                  }
                                },
                              );
                            })))
                        .values
                        .toList())),
                Divider(),
                Txt("Sistem",
                    style: TxtStyle()
                      ..textColor(Colors.grey[500])
                      ..margin(left: 0.05.sw)),
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text('Tentang'),
                  onTap: () {
                    controller.about();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.power_settings_new),
                  title: Text('Logout'),
                  onTap: () {
                    controller.confirmLogout();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
