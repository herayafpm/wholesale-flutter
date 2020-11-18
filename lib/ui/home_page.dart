import 'package:division/division.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:wholesale/models/user_model.dart';
import 'package:wholesale/static_data.dart';
import 'package:wholesale/ui/distributor/barang/manajemen_barang_distributor_page.dart';
import 'package:wholesale/ui/distributor/mitra/manajemen_mitra_page.dart';
import 'package:wholesale/ui/share/dashboard_page.dart';
import 'package:wholesale/ui/share/profile_page.dart';
import 'package:wholesale/ui/toko/karyawan/manajemen_karyawan_page.dart';
import 'package:wholesale/ui/toko/profile_toko_page.dart';
import 'package:wholesale/utils/role_utils.dart';

class HomeController extends GetxController {
  final obj = ''.obs;
  final userModel = UserModel().obs;
  final page = 0.obs;

  final listDrawer = [].obs;
  final listPage = [].obs;

  @override
  void onInit() async {
    initMyLibrary();
    try {
      var boxUser = await Hive.openBox("user_model");
      UserModel user = boxUser.getAt(0);
      if (user != null) {
        userModel.value = user;
      }
      if (RoleUtils.isDistributor(user.role_id)) {
        listDrawer.value = [
          {"title": "Dashboard", "icon": Icon(Icons.dashboard)},
          {"title": "Profile", "icon": Icon(Icons.account_box)},
          {"title": "Barang", "icon": Icon(Icons.local_offer)},
          {"title": "Data Penjualan", "icon": Icon(Icons.bar_chart)},
          {"title": "Keuangan", "icon": Icon(Icons.account_balance_wallet)},
          {"title": "Manajemen Mitra", "icon": Icon(Icons.group)},
        ];
        listPage.value = [
          DashboardPage(),
          ProfilePage(),
          ManajemenBarangDistributorPage(),
          Container(),
          Container(),
          ManajemenMitraPage(),
        ];
      } else if (RoleUtils.isPemilikToko(user.role_id)) {
        listDrawer.value = [
          {"title": "Dashboard", "icon": Icon(Icons.dashboard)},
          {"title": "Profile", "icon": Icon(Icons.account_box)},
          {"title": "Profile Toko", "icon": Icon(Icons.account_box)},
          {"title": "Barang", "icon": Icon(Icons.local_offer)},
          {"title": "Data Penjualan", "icon": Icon(Icons.bar_chart)},
          {"title": "Tangungan", "icon": Icon(Icons.account_balance_wallet)},
          {"title": "Manajemen Karyawan", "icon": Icon(Icons.group)},
        ];
        listPage.value = [
          DashboardPage(),
          ProfilePage(),
          ProfileTokoPage(),
          Container(),
          Container(),
          Container(),
          ManajemenKaryawanPage()
        ];
      } else {
        listDrawer.value = [
          {"title": "Dashboard", "icon": Icon(Icons.dashboard)},
          {"title": "Profile", "icon": Icon(Icons.account_box)},
          {"title": "Barang", "icon": Icon(Icons.local_offer)},
          {"title": "Transaksi", "icon": Icon(Icons.bar_chart)},
          {"title": "Data Transaksi", "icon": Icon(Icons.bar_chart)},
        ];
        listPage.value = [
          DashboardPage(),
          ProfilePage(),
          Container(),
          Container(),
          Container(),
        ];
      }
    } catch (e) {
      Get.offAllNamed("/login");
    }
    super.onInit();
  }

  void initMyLibrary() {
    LicenseRegistry.addLicense(() async* {
      yield LicenseEntryWithLineBreaks(
          <String>['Freepik - www.freepik.com'], """
          - falling-stars-beautiful-night-background_5376553
          """);
    });
  }

  void about() {
    showAboutDialog(
        context: Get.context,
        applicationName: "Wholesale",
        applicationVersion: "1.0",
        applicationIcon: SizedBox(
          width: Get.width * 0.1,
          child: Image.asset(
            "assets/images/icon.png",
            fit: BoxFit.contain,
          ),
        ));
  }

  void confirmLogout() {
    showDialog(
        context: Get.context,
        builder: (context) => AlertDialog(
              actions: [
                FlatButton(
                  child: Text("Tidak"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Ya"),
                  onPressed: () {
                    logout();
                  },
                )
              ],
              title: Txt("Konfirmasi"),
              content: Txt("Yakin ingin mengakhiri sesi?"),
            ));
  }

  void logout() async {
    var boxUser = await Hive.openBox("user_model");
    boxUser.deleteAt(0);
    Get.offAllNamed("/login");
  }
}

class HomePage extends GetView<HomeController> {
  final controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(StaticData.screenWidth, StaticData.screenHeight),
        allowFontScaling: true);
    return Scaffold(
      appBar: AppBar(
        title: Obx(() =>
            Txt(controller.listDrawer[controller.page.value]['title'] ?? "")),
      ),
      body: Obx(() => controller.listPage[controller.page.value]),
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
                          if (index == 4 &&
                              controller.userModel.value.role_id != 1) {
                            return Container();
                          } else {
                            return ListTile(
                              selected: index == controller.page.value,
                              leading: value['icon'],
                              title: Text(value['title']),
                              onTap: () {
                                controller.page.value = index;
                                Navigator.pop(context);
                              },
                            );
                          }
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
    );
  }
}
