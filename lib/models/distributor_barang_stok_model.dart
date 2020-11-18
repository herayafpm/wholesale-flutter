class DistributorBarangStokModel {
  int id;
  int barang_id;
  int stok_sekarang;
  int stok_perubahan;
  String keterangan;

  DistributorBarangStokModel(
      {this.id = 0,
      this.barang_id,
      this.stok_sekarang,
      this.stok_perubahan,
      this.keterangan});

  factory DistributorBarangStokModel.createFromJson(Map<String, dynamic> json) {
    return DistributorBarangStokModel(
      id: int.parse(json['id']),
      barang_id: int.parse(json['barang_id']),
      stok_sekarang: int.parse(json['stok_sekarang']),
      stok_perubahan: int.parse(json['stok_perubahan']),
      keterangan: json['keterangan'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stok'] = this.stok_perubahan;
    data['keterangan'] = this.keterangan;
    return data;
  }
}
