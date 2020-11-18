class TokoModel {
  int id;
  String username;
  String nama;
  String email;
  String alamat;
  String no_telp;

  TokoModel(
      {this.id = 0,
      this.username,
      this.nama,
      this.alamat,
      this.email,
      this.no_telp});

  factory TokoModel.createFromJson(Map<String, dynamic> json) {
    return TokoModel(
      id: int.parse(json['id']),
      username: json['username'],
      nama: json['nama_toko'],
      alamat: json['alamat'],
      email: json['email'],
      no_telp: json['no_telp'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['nama_toko'] = this.nama;
    data['alamat'] = this.alamat;
    data['email'] = this.email;
    data['no_telp'] = this.no_telp;
    return data;
  }
}
