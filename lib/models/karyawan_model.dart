class KaryawanModel {
  int id;
  String username;
  String nama;
  String email;
  String alamat;
  String no_telp;

  KaryawanModel(
      {this.id = 0,
      this.username,
      this.nama,
      this.alamat,
      this.email,
      this.no_telp});

  factory KaryawanModel.createFromJson(Map<String, dynamic> json) {
    return KaryawanModel(
      id: int.parse(json['id']),
      username: json['user_username'],
      nama: json['user_nama'],
      alamat: json['user_alamat'],
      email: json['user_email'],
      no_telp: json['user_no_telp'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['nama'] = this.nama;
    data['alamat'] = this.alamat;
    data['email'] = this.email;
    data['no_telp'] = this.no_telp;
    return data;
  }
}
