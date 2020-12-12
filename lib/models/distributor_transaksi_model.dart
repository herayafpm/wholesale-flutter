import 'package:hive/hive.dart';
import 'package:wholesale/models/distributor_barang_model.dart';
import 'package:wholesale/models/distributor_pelunasan_model.dart';

import 'toko_model.dart';

class DistributorTransaksiModel extends HiveObject {
  int id;
  TokoModel toko;
  int total_bayar;
  int bayar;
  bool status;
  List<DistributorBarangModel> barangs;
  List<DistributorPelunasanModel> pelunasans;
  List<int> jumlahs;
  List<int> harga_juals;
  String keterangan;
  String created_at;
  int jumlah;
  int jumlah_bayar;

  DistributorTransaksiModel(
      {this.id = 0,
      this.toko,
      this.total_bayar,
      this.bayar,
      this.status,
      this.barangs,
      this.jumlahs,
      this.harga_juals,
      this.keterangan = '',
      this.pelunasans,
      this.jumlah,
      this.jumlah_bayar,
      this.created_at});

  factory DistributorTransaksiModel.createFromJson(Map<String, dynamic> json) {
    List<DistributorBarangModel> barangs = [];
    List<int> jumlahs = [];
    List<int> harga_juals = [];
    int jumlah = 0;
    int jumlah_bayar = 0;
    for (var penjualan in json['penjualan']) {
      barangs.add(DistributorBarangModel(
          id: int.parse(penjualan['barang_distributor_id']),
          nama_barang: penjualan['nama_barang'],
          foto: penjualan['foto']));
      jumlah += int.parse(penjualan['jumlah_barang']);
      jumlah_bayar += int.parse(penjualan['jumlah_barang']) *
          int.parse(penjualan['harga_jual']);
      jumlahs.add(int.parse(penjualan['jumlah_barang']));
      harga_juals.add(int.parse(penjualan['harga_jual']));
    }
    String keterangan = "";
    List<DistributorPelunasanModel> pelunasans = [];
    for (var pelunasan in json['pelunasan']) {
      pelunasans.add(DistributorPelunasanModel.createFromJson(pelunasan));
      keterangan = pelunasan['keterangan'];
    }
    return DistributorTransaksiModel(
      id: int.parse(json['id']),
      toko: TokoModel(id: int.parse(json['toko_id']), nama: json['nama_toko']),
      total_bayar: int.parse(json['total_bayar']),
      bayar: int.parse(json['bayar']),
      status: json['status'] == "1",
      barangs: barangs,
      pelunasans: pelunasans,
      jumlahs: jumlahs,
      jumlah: jumlah,
      jumlah_bayar: jumlah_bayar,
      harga_juals: harga_juals,
      keterangan: keterangan,
      created_at: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> barangs = [];
    int no = 0;
    for (DistributorBarangModel barang in this.barangs) {
      Map<String, dynamic> b = Map<String, dynamic>();
      b['id'] = barang.id;
      b['jumlah_barang'] = -this.jumlahs[no];
      b['harga_jual'] = this.harga_juals[no];
      barangs.add(b);
      no++;
    }
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['toko_id'] = this.toko.id;
    data['barang'] = barangs;
    data['bayar'] = this.bayar;
    if (this.keterangan.isNotEmpty) {
      data['keterangan'] = this.keterangan;
    }
    return data;
  }
}
