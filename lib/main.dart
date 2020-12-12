import 'dart:isolate';
import 'dart:ui';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart' as Trans;
import 'package:hive/hive.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:wholesale/models/user_model.dart';
import 'package:wholesale/splash_screen_page.dart';
import 'package:wholesale/ui/auth/forgot_pass_page.dart';
import 'package:wholesale/ui/auth/login_page.dart';
import 'package:wholesale/ui/distributor/barang/detail_barang_distributor_page.dart';
import 'package:wholesale/ui/distributor/barang/edit_distributor_barang_page.dart';
import 'package:wholesale/ui/distributor/barang/manajemen_jenis_barang_page.dart';
import 'package:wholesale/ui/distributor/barang/manajemen_ukuran_barang_page.dart';
import 'package:wholesale/ui/distributor/barang/stok/manajemen_stok_barang_distributor_page.dart';
import 'package:wholesale/ui/distributor/barang/stok/tambah_stok_barang_distributor_page.dart';
import 'package:wholesale/ui/distributor/barang/tambah_distributor_barang_page.dart';
import 'package:wholesale/ui/distributor/mitra/list_barang_mitra_page.dart';
import 'package:wholesale/ui/distributor/mitra/tambah_mitra_page.dart';
import 'package:wholesale/ui/distributor/mitra/transaksi/barang_transaksi_mitra_page.dart';
import 'package:wholesale/ui/distributor/mitra/transaksi/list_pelunasan_transaksi_mitra_page.dart';
import 'package:wholesale/ui/distributor/mitra/transaksi/manajemen_transaksi_mitra_page.dart';
import 'package:wholesale/ui/distributor/mitra/transaksi/pelunasan_transaksi_mitra_page.dart';
import 'package:wholesale/ui/distributor/transaksi/keranjang_distributor_page.dart';
import 'package:wholesale/ui/distributor/transaksi/pembayaran_distributor_page.dart';
import 'package:wholesale/ui/distributor/transaksi/transasksi_distributor_page.dart';
import 'package:wholesale/ui/home_page.dart';
import 'package:wholesale/ui/karyawan/transaksi/keranjang_toko_page.dart';
import 'package:wholesale/ui/karyawan/transaksi/pembayaran_toko_page.dart';
import 'package:wholesale/ui/karyawan/transaksi/transasksi_toko_page.dart';
import 'package:wholesale/ui/share/image_view.dart';
import 'package:wholesale/ui/share/profile_edit_page.dart';
import 'package:wholesale/ui/toko/barang/detail_barang_toko_page.dart';
import 'package:wholesale/ui/toko/barang/edit_barang_toko_page.dart';
import 'package:wholesale/ui/toko/karyawan/tambah_karyawan_page.dart';
import 'package:wholesale/ui/toko/profile_toko_edit_page.dart';
import 'package:wholesale/ui/toko/tanggungan/barang_tanggungan_toko_page.dart';
import 'package:wholesale/ui/toko/tanggungan/detail_tanggungan_toko_page.dart';
import 'package:wholesale/ui/toko/tanggungan/list_pelunasan_tanggungan_toko_page.dart';
import 'package:wholesale/ui/toko/transaksi/barang_transaksi_toko_page.dart';
import 'package:wholesale/utils/workmanager_utils.dart';
import 'package:workmanager/workmanager.dart';

import 'ui/distributor/mitra/transaksi/detail_transaksi_mitra_page.dart';

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    final sendPort = IsolateNameServer.lookupPortByName('port');
    assert(sendPort != null);
    var port = ReceivePort();
    var completer = Completer<bool>();
    StreamSubscription subscription;
    subscription = port.listen((message) {
      bool result = message;
      completer.complete(result);
      subscription.cancel();
    });
    sendPort.send([port.sendPort, task, inputData]);
    var appDocumentDirectory =
        await pathProvider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
    Hive.registerAdapter(UserModelAdapter());
    return completer.future;
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  var appDocumentDirectory =
      await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(UserModelAdapter());
  OneSignal.shared
      .init("246fbd22-450f-4ffb-b5b6-5bc03fbf6046", iOSSettings: null);
  Workmanager.initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          false // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );
  var port = ReceivePort();
  IsolateNameServer.removePortNameMapping('port');
  IsolateNameServer.registerPortWithName(port.sendPort, 'port');
  port.listen((dynamic data) async {
    SendPort sendPort = data[0];
    sendPort.send(WorkManagerUtils.runWork(task: data[1], inputData: data[2]));
  });
  runApp(App());
}

final ThemeData appThemeData = ThemeData(
  scaffoldBackgroundColor: Color(0xFF29ABA4),
  primaryColor: Colors.blueAccent,
  primarySwatch: Colors.blue,
  appBarTheme: AppBarTheme(color: Colors.transparent, elevation: 0),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  fontFamily: 'Roboto',
  textTheme: TextTheme(
    headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
  ),
);

class AppController extends GetxController {
  @override
  void onInit() {
    OneSignal.shared
        .setNotificationReceivedHandler((OSNotification notification) {
      // will be called whenever a notification is received
      print("data ${notification.payload.title}");
      print("data ${notification.payload.body}");
    });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print("data di tap ${result.action.type}");
    });
    super.onInit();
  }
}

class App extends StatelessWidget {
  final controller = Get.put(AppController());
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Wholesale",
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      theme: appThemeData,
      defaultTransition: Trans.Transition.fadeIn,
      getPages: [
        GetPage(name: "/", page: () => SplashScreenPage()),
        GetPage(name: "/image_view", page: () => ImageView()),
        // Auth
        GetPage(name: "/login", page: () => LoginPage()),
        GetPage(name: "/forgotpass", page: () => ForgotPassPage()),
        // Profile
        GetPage(name: "/editprofile", page: () => ProfileEditPage()),
        // Distributor - Mitra
        GetPage(name: "/tambahmitra", page: () => TambahMitraPage()),
        // Distributor - Manajemen Transaksi Mitra
        GetPage(
            name: "/manajementransaksimitra",
            page: () => ManajemenTransaksiMitraPage()),
        // Distributor - Detail Transaksi Mitra
        GetPage(
            name: "/detailtransaksimitra",
            page: () => DetailTransaksiMitraPage()),
        // Distributor - Barang Transaksi Mitra
        GetPage(
            name: "/barangtransaksimitra",
            page: () => BarangTransaksiMitraPage()),
        // Distributor - List Pelunasan Transaksi Mitra
        GetPage(
            name: "/listpelunasantransaksimitra",
            page: () => ListPelunasanTransaksiMitraPage()),
        // Distributor - Pelunasan Transaksi Mitra
        GetPage(
            name: "/pelunasantransaksimitra",
            page: () => PelunasanTransaksiMitraPage()),
        // Distributor - Barang Mitra
        GetPage(name: "/listbarangmitra", page: () => ListBarangMitraPage()),
        // Distributor - Jenis Barang
        GetPage(name: "/jenisbarang", page: () => ManajemenJenisBarangPage()),
        // Distributor - Ukuran Barang
        GetPage(name: "/ukuranbarang", page: () => ManajemenUkuranBarangPage()),
        // Distributor - Detail Barang
        GetPage(
            name: "/distributorbarang",
            page: () => DetailBarangDistributorPage()),
        // Distributor - Tambah Barang
        GetPage(
            name: "/distributortambahbarang",
            page: () => TambahDistributorBarangPage()),
        // Distributor - Edit Barang
        GetPage(
            name: "/distributoreditbarang",
            page: () => EditDistributorBarangPage()),
        // Distributor - Riwayat Stok Barang
        GetPage(
            name: "/distributorstokbarang",
            page: () => ManajemenStokBarangDistributorPage()),
        // Distributor - Tambah Stok Barang
        GetPage(
            name: "/distributortambahstokbarang",
            page: () => TambahStokBarangDistributorPage()),
        // Distributor - Transaksi Distributor
        GetPage(
            name: "/transaksidistributor",
            page: () => TransaksiDistributorPage()),
        // Distributor - Keranjang Distributor
        GetPage(
            name: "/keranjangdistributor",
            page: () => KeranjangDistributorPage()),
        // Distributor - Pembayaran Distributor
        GetPage(
            name: "/pemabayarandistributor",
            page: () => PembayaranDistributorPage()),
        // Distributor - Barang Transaksi Toko
        GetPage(
            name: "/barangtransaksitoko",
            page: () => BarangTransaksiTokoPage()),
        // Toko - Profile
        GetPage(name: "/editprofiletoko", page: () => ProfileTokoEditPage()),
        // Toko - Detail Barang
        GetPage(name: "/detailbarangtoko", page: () => DetailBarangTokoPage()),
        // Toko - Edit Barang
        GetPage(name: "/editbarangtoko", page: () => EditBarangTokoPage()),
        // Toko - Karyawan - Tambah
        GetPage(name: "/tambahkaryawan", page: () => TambahKaryawanPage()),
        // Distributor - Detail Tanggungan Toko
        GetPage(
            name: "/detailtanggungantoko",
            page: () => DetailTanggunganTokoPage()),
        // Distributor - Barang Transaksi Mitra
        GetPage(
            name: "/barangtanggungantoko",
            page: () => BarangTanggunganTokoPage()),
        // Distributor - List Pelunasan Transaksi Mitra
        GetPage(
            name: "/listpelunasantanggungantoko",
            page: () => ListPelunasanTanggunganTokoPage()),
        // Distributor - Transaksi Toko
        GetPage(name: "/transaksitoko", page: () => TransaksiTokoPage()),
        // toko - Keranjang Toko
        GetPage(name: "/keranjangtoko", page: () => KeranjangTokoPage()),
        // toko - Pembayaran Toko
        GetPage(name: "/pemabayarantoko", page: () => PembayaranTokoPage()),
        GetPage(name: "/home", page: () => HomePage()),
      ],
    );
  }
}
