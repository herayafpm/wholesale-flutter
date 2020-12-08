class TokoBarangModel {
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
  String created_at;
  String updated_at;

  TokoBarangModel(
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
      this.jenis_barang_nama,
      this.created_at,
      this.updated_at});

  factory TokoBarangModel.createFromJson(Map<String, dynamic> json) {
    return TokoBarangModel(
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
      created_at: json['created_at'],
      updated_at: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['harga_jual'] = this.harga_jual;
    data['keterangan'] = this.keterangan;
    return data;
  }
}
