import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
class UserModel extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  String username;
  @HiveField(2)
  String nama;
  @HiveField(3)
  String email;
  @HiveField(4)
  String alamat;
  @HiveField(5)
  String no_telp;
  @HiveField(6)
  int role_id;
  @HiveField(7)
  String role_nama;
  @HiveField(8)
  String token;

  UserModel(
      {this.id = 0,
      this.username,
      this.nama,
      this.alamat,
      this.email,
      this.no_telp,
      this.role_id,
      this.role_nama,
      this.token});

  factory UserModel.createFromJson(Map<String, dynamic> json) {
    return UserModel(
      id: int.parse(json['id']),
      username: json['username'],
      nama: json['nama'],
      alamat: json['alamat'],
      email: json['email'],
      no_telp: json['no_telp'],
      role_id: int.parse(json['role_id']),
      role_nama: json['role_nama'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['nama'] = this.nama;
    data['alamat'] = this.alamat;
    data['email'] = this.email;
    data['no_telp'] = this.no_telp;
    data['role_id'] = this.role_id;
    data['role_nama'] = this.role_nama;
    data['token'] = this.token;
    return data;
  }
}
