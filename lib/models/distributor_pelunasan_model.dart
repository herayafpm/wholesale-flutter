class DistributorPelunasanModel {
  int id;
  int transaksi_penjualan_id;
  int bayar_sebelumnya;
  int bayar;
  String keterangan;
  String created_at;

  DistributorPelunasanModel(
      {this.id = 0,
      this.transaksi_penjualan_id,
      this.bayar_sebelumnya,
      this.bayar,
      this.keterangan,
      this.created_at});

  factory DistributorPelunasanModel.createFromJson(Map<String, dynamic> json) {
    return DistributorPelunasanModel(
      id: int.parse(json['id']),
      transaksi_penjualan_id: int.parse(json['transaksi_penjualan_id']),
      bayar_sebelumnya: int.parse(json['bayar_sebelumnya']),
      bayar: int.parse(json['bayar']),
      keterangan: json['keterangan'],
      created_at: json['created_at'],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['bayar'] = this.bayar;
    if (this.keterangan.isNotEmpty) {
      data['keterangan'] = this.keterangan;
    }
    return data;
  }
}
