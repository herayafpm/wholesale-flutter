import 'package:hive/hive.dart';
import 'package:wholesale/models/user_model.dart';

abstract class RoleUtils {
  static bool isDistributor(int role) {
    return role == 1;
  }

  static Future<bool> whatRole(int role) async {
    try {
      var boxUser = await Hive.openBox("user_model");
      UserModel user = boxUser.getAt(0);
      if (user.role_id == 1 && role == user.role_id) {
        return true;
      } else if (user.role_id == 2 && role == user.role_id) {
        return true;
      } else if (user.role_id == 3 && role == user.role_id) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static bool isPemilikToko(int role) {
    return role == 2;
  }

  static bool isKaryawan(int role) {
    return role == 3;
  }
}
