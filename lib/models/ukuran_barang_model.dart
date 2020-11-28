class UkuranBarangModel {
  int id;
  String nama;

  UkuranBarangModel({
    this.id = 0,
    this.nama,
  });

  factory UkuranBarangModel.createFromJson(Map<String, dynamic> json) {
    return UkuranBarangModel(
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
