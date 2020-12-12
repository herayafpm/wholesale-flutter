import 'dart:io';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class ManajemenPrinterController extends GetxController {
  final connected = false.obs;
  final pressed = false.obs;
  final pathImage = "".obs;

  @override
  void onInit() {
    // TODO: implement onInit
    print("data okasan");
    initPrinter();
    super.onInit();
  }

  void initPrinter() {
    initPlatformState();
    initSavetoPath();
  }

  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  final deviceBluetooths = [].obs;
  BluetoothDevice deviceBluetooth;

  initSavetoPath() async {
    //read and write
    //image max 300px X 300px
    final filename = 'icon.png';
    var bytes = await rootBundle.load("assets/images/$filename");
    String dir = (await getApplicationDocumentsDirectory()).path;
    writeToFile(bytes, '$dir/$filename');
    pathImage.value = '$dir/$filename';
  }

  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Future<void> initPlatformState() async {
    List<BluetoothDevice> devices = [];

    try {
      devices = await bluetooth.getBondedDevices();
      print("data $devices");
    } on PlatformException {
      // TODO - Error
    }

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          connected.value = true;
          pressed.value = false;
          break;
        case BlueThermalPrinter.DISCONNECTED:
          connected.value = false;
          pressed.value = false;
          break;
        default:
          print(state);
          break;
      }
    });
    deviceBluetooths.value = devices;
  }

  void itemOnTap(BluetoothDevice device) {
    deviceBluetooth = device;
    update();
    connectBluetooth();
  }

  void connectBluetooth() {
    if (deviceBluetooth == null) {
      print('data No device selected.');
    } else {
      bluetooth.isConnected.then((isConnected) {
        if (!isConnected) {
          bluetooth.connect(deviceBluetooth).catchError((error) {
            pressed.value = false;
          });
          pressed.value = true;
        }
      });
    }
  }

  void tesPrint() async {
    //SIZE
    // 0- normal size text
    // 1- only bold text
    // 2- bold with medium text
    // 3- bold with large text
    //ALIGN
    // 0- ESC_ALIGN_LEFT
    // 1- ESC_ALIGN_CENTER
    // 2- ESC_ALIGN_RIGHT
    bluetooth.isConnected.then((isConnected) {
      if (isConnected) {
        bluetooth.printCustom("HEADER", 3, 1);
        bluetooth.printNewLine();
        bluetooth.printImage(pathImage.value);
        bluetooth.printNewLine();
        bluetooth.printLeftRight("LEFT", "RIGHT", 0);
        bluetooth.printLeftRight("LEFT", "RIGHT", 1);
        bluetooth.printNewLine();
        bluetooth.printLeftRight("LEFT", "RIGHT", 2);
        bluetooth.printCustom("Body left", 1, 0);
        bluetooth.printCustom("Body right", 0, 2);
        bluetooth.printNewLine();
        bluetooth.printCustom("Terimakasih", 2, 1);
        bluetooth.printNewLine();
        bluetooth.printQRcode("Heraya Tamvan", 50, 50, 1);
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.paperCut();
      }
    });
  }

  void disconnectBluetooth() {
    bluetooth.disconnect();
    pressed.value = true;
  }
}
