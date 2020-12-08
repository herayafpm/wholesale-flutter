import 'package:hive/hive.dart';
import 'package:wholesale/models/karyawan_model.dart';
import 'package:wholesale/models/toko_barang_model.dart';

import 'toko_model.dart';

class TokoTransaksiModel extends HiveObject {
  int id;
  TokoModel toko;
  KaryawanModel karyawan;
  int total_bayar;
  int bayar;
  List<TokoBarangModel> barangs;
  List<int> jumlahs;
  List<int> harga_juals;
  String created_at;
  int jumlah;
  int jumlah_bayar;

  TokoTransaksiModel(
      {this.id = 0,
      this.toko,
      this.total_bayar,
      this.karyawan,
      this.bayar,
      this.barangs,
      this.jumlahs,
      this.harga_juals,
      this.jumlah,
      this.jumlah_bayar,
      this.created_at});

  factory TokoTransaksiModel.createFromJson(Map<String, dynamic> json) {
    List<TokoBarangModel> barangs = [];
    List<int> jumlahs = [];
    List<int> harga_juals = [];
    int jumlah = 0;
    int jumlah_bayar = 0;
    for (var penjualan in json['penjualan']) {
      barangs.add(TokoBarangModel(
          id: int.parse(penjualan['barang_toko_id']),
          nama_barang: penjualan['nama_barang'],
          foto: penjualan['foto']));
      jumlah += int.parse(penjualan['jumlah_barang']);
      jumlah_bayar += int.parse(penjualan['jumlah_barang']) *
          int.parse(penjualan['harga_jual']);
      jumlahs.add(int.parse(penjualan['jumlah_barang']));
      harga_juals.add(int.parse(penjualan['harga_jual']));
    }
    return TokoTransaksiModel(
      id: int.parse(json['id']),
      toko: TokoModel(id: int.parse(json['toko_id']), nama: json['nama_toko']),
      karyawan: KaryawanModel(
          id: int.parse(json['karyawan_id']), nama: json['karyawan_nama']),
      total_bayar: int.parse(json['total_bayar']),
      bayar: int.parse(json['bayar']),
      barangs: barangs,
      jumlahs: jumlahs,
      jumlah: jumlah,
      jumlah_bayar: jumlah_bayar,
      harga_juals: harga_juals,
      created_at: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> barangs = [];
    int no = 0;
    for (TokoBarangModel barang in this.barangs) {
      Map<String, dynamic> b = Map<String, dynamic>();
      b['id'] = barang.id;
      b['jumlah_barang'] = -this.jumlahs[no];
      b['harga_jual'] = this.harga_juals[no];
      barangs.add(b);
      no++;
    }
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['barang'] = barangs;
    data['bayar'] = this.bayar;
    return data;
  }
}
