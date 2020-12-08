import 'package:division/division.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:wholesale/models/user_model.dart';
import 'package:wholesale/repositories/toko/toko_repository.dart';
import 'package:wholesale/ui/distributor/barang/manajemen_barang_distributor_page.dart';
import 'package:wholesale/ui/distributor/dashboard_distributor_page.dart';
import 'package:wholesale/ui/distributor/mitra/manajemen_mitra_page.dart';
import 'package:wholesale/ui/distributor/penjualan/data_penjualan_distributor_page.dart';
import 'package:wholesale/ui/karyawan/dashboard_karyawan_page.dart';
import 'package:wholesale/ui/share/profile_page.dart';
import 'package:wholesale/ui/toko/barang/manajemen_barang_toko_page.dart';
import 'package:wholesale/ui/toko/dashboard_toko_page.dart';
import 'package:wholesale/ui/toko/karyawan/manajemen_karyawan_page.dart';
import 'package:wholesale/ui/toko/penjualan/data_penjualan_toko_page.dart';
import 'package:wholesale/ui/toko/profile_toko_page.dart';
import 'package:wholesale/ui/toko/tanggungan/tanggungan_toko_page.dart';
import 'package:wholesale/ui/toko/transaksi/list_transaksi_toko_page.dart';
import 'package:wholesale/utils/role_utils.dart';

class HomeController extends GetxController {
  final obj = ''.obs;
  final userModel = UserModel().obs;
  final page = 0.obs;
  final role = 0.obs;

  final listDrawer = [].obs;
  final listPage = [].obs;
  List<Widget> actionsList = [];
  void updateListBarang() {
    actionsList = [
      PopupMenuButton<String>(
        onSelected: (choice) {
          if (choice == "jenis") {
            Get.toNamed("/jenisbarang");
          } else if (choice == "ukuran") {
            Get.toNamed("/ukuranbarang");
          }
        },
        itemBuilder: (BuildContext context) {
          return ["jenis", "ukuran"].map((String choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: Text(choice.capitalizeFirst + " Barang"),
            );
          }).toList();
        },
      )
    ];
    update();
  }

  @override
  void onInit() async {
    initMyLibrary();
    try {
      var boxUser = await Hive.openBox("user_model");
      UserModel user = boxUser.getAt(0);
      if (user != null) {
        userModel.value = user;
      }
      role.value = user.role_id;
      if (RoleUtils.isDistributor(user.role_id)) {
        listDrawer.value = [
          {"title": "Dashboard", "icon": Icon(Icons.dashboard)},
          {"title": "Profile", "icon": Icon(Icons.account_box)},
          {"title": "Barang", "icon": Icon(Icons.local_offer)},
          {"title": "Data Penjualan", "icon": Icon(Icons.bar_chart)},
          {"title": "Manajemen Mitra", "icon": Icon(Icons.group)},
        ];
        listPage.value = [
          DashboardDistributorPage(),
          ProfilePage(),
          ManajemenBarangDistributorPage(),
          DataPenjualanDistributorPage(),
          ManajemenMitraPage(),
        ];
      } else if (RoleUtils.isPemilikToko(user.role_id)) {
        listDrawer.value = [
          {"title": "Dashboard", "icon": Icon(Icons.dashboard)},
          {"title": "Profile", "icon": Icon(Icons.account_box)},
          {"title": "Profile Toko", "icon": Icon(Icons.account_box)},
          {"title": "Barang", "icon": Icon(Icons.local_offer)},
          {"title": "Transaksi", "icon": Icon(Icons.monetization_on)},
          {"title": "Data Penjualan", "icon": Icon(Icons.bar_chart)},
          {"title": "Tangungan", "icon": Icon(Icons.account_balance_wallet)},
          {"title": "Manajemen Karyawan", "icon": Icon(Icons.group)},
        ];
        listPage.value = [
          DashboardTokoPage(),
          ProfilePage(),
          ProfileTokoPage(),
          ManajemenBarangTokoPage(),
          ListTransaksiTokoPage(),
          DataPenjualanTokoPage(),
          TanggunganTokoPage(),
          ManajemenKaryawanPage()
        ];
      } else {
        listDrawer.value = [
          {"title": "Dashboard", "icon": Icon(Icons.dashboard)},
          {"title": "Profile", "icon": Icon(Icons.account_box)},
          {"title": "Barang", "icon": Icon(Icons.local_offer)},
          {"title": "Transaksi", "icon": Icon(Icons.monetization_on)},
          {"title": "Printer", "icon": Icon(Icons.print)},
        ];
        listPage.value = [
          DashboardKaryawanPage(),
          ProfilePage(),
          ManajemenBarangTokoPage(),
          ListTransaksiTokoPage(),
          Container(),
        ];
      }
      var status = await OneSignal.shared.getPermissionSubscriptionState();

      if (status.permissionStatus.hasPrompted) {
        print("data ${status.permissionStatus.hasPrompted}");
      }
      // we know that the user was prompted for push permission

      if (status.permissionStatus.status ==
          OSNotificationPermission.notDetermined) {
        print("data user enabled notif");
      }

      // boolean telling you if the user enabled notifications

      if (status.subscriptionStatus.subscribed) {
        print("data user is subscribed");
      }

      // boolean telling you if the user is subscribed with OneSignal's backend

      // the user's ID with OneSignal
      String onesignalUserId = status.subscriptionStatus.userId;
      print("data onesignal $onesignalUserId");
      print("data ${user.role_id}");
      if (user.role_id == 2) {
        await TokoRepository.updateTokenToko(onesignalUserId);
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
