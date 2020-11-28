import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart' as Trans;
import 'package:hive/hive.dart';
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
import 'package:wholesale/ui/distributor/mitra/tambah_mitra_page.dart';
import 'package:wholesale/ui/distributor/transaksi/transasksi_distributor_page.dart';
import 'package:wholesale/ui/home_page.dart';
import 'package:wholesale/ui/share/image_view.dart';
import 'package:wholesale/ui/share/profile_edit_page.dart';
import 'package:wholesale/ui/toko/karyawan/tambah_karyawan_page.dart';
import 'package:wholesale/ui/toko/profile_toko_edit_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  var appDocumentDirectory =
      await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(UserModelAdapter());
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

class App extends StatelessWidget {
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

        // Toko - Profile
        GetPage(name: "/editprofiletoko", page: () => ProfileTokoEditPage()),
        // Toko - Karyawan - Tambah
        GetPage(name: "/tambahkaryawan", page: () => TambahKaryawanPage()),
        GetPage(name: "/home", page: () => HomePage()),
      ],
    );
  }
}
