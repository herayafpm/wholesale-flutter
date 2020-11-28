class JenisBarangModel {
  int id;
  String nama;

  JenisBarangModel({
    this.id = 0,
    this.nama,
  });

  factory JenisBarangModel.createFromJson(Map<String, dynamic> json) {
    return JenisBarangModel(
      id: int.parse(json['id']),
      nama: json['nama'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nama'] = this.nama;
    return data;
  }
}
