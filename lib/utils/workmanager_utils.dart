import 'package:hive/hive.dart';
import 'package:wholesale/repositories/toko/toko_repository.dart';
import 'package:workmanager/workmanager.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class WorkManagerUtils {
  static const logoutTaskKey = "logoutTask";
  static const simpleDelayedTask = "simpleDelayedTask";
  static const simplePeriodicTask = "simplePeriodicTask";
  static const simplePeriodic1HourTask = "simplePeriodic1HourTask";
  static Future<void> logoutWork(Map<String, dynamic> inputData) async {
    Map<String, dynamic> data = inputData;
    print(
        "${WorkManagerUtils.logoutTaskKey} was exekusi. inputData = $inputData");
    if (data['role'] == 2) {
      await TokoRepository.updateTokenToko("");
    }
    var boxUser = await Hive.openBox("user_model");
    boxUser.deleteAt(0);
    return Future.value(true);
  }

  static Future<bool> runWork(
      {String task, Map<String, dynamic> inputData}) async {
    switch (task) {
      case WorkManagerUtils.logoutTaskKey:
        await WorkManagerUtils.logoutWork(inputData);
        break;
      case Workmanager.iOSBackgroundTask:
        print("The iOS background fetch was triggered");
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        print(
            "You can access other plugins in the background, for example Directory.getTemporaryDirectory(): $tempPath");
        break;
    }
    return true;
  }
}
