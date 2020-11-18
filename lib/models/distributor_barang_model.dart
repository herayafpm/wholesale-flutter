class DistributorBarangModel {
  int id;
  String foto;
  String nama_barang;
  int jenis_barang_id;
  int ukuran_barang_id;
  int stok;
  int harga_dasar;
  int harga_jual;
  String keterangan;
  String ukuran_barang_nama;
  String jenis_barang_nama;

  DistributorBarangModel(
      {this.id = 0,
      this.foto,
      this.nama_barang,
      this.jenis_barang_id,
      this.ukuran_barang_id,
      this.stok,
      this.harga_dasar,
      this.harga_jual,
      this.keterangan,
      this.ukuran_barang_nama,
      this.jenis_barang_nama});

  factory DistributorBarangModel.createFromJson(Map<String, dynamic> json) {
    return DistributorBarangModel(
      id: int.parse(json['id']),
      foto: json['foto'],
      nama_barang: json['nama_barang'],
      jenis_barang_id: int.parse(json['jenis_barang_id']),
      ukuran_barang_id: int.parse(json['ukuran_barang_id']),
      stok: int.parse(json['stok']),
      harga_dasar: int.parse(json['harga_dasar']),
      harga_jual: int.parse(json['harga_jual']),
      keterangan: json['keterangan'],
      ukuran_barang_nama: json['ukuran_barang_nama'],
      jenis_barang_nama: json['jenis_barang_nama'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['foto'] = this.foto;
    data['nama_barang'] = this.nama_barang;
    data['jenis_barang_id'] = this.jenis_barang_id;
    data['ukuran_barang_id'] = this.ukuran_barang_id;
    data['stok'] = this.stok;
    data['harga_dasar'] = this.harga_dasar;
    data['harga_jual'] = this.harga_jual;
    data['keterangan'] = this.keterangan;
    return data;
  }
}
