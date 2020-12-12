import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:wholesale/utils/convert_utils.dart';

class ManajemenPrinterController extends GetxController {
  PrinterBluetoothManager printerManager = PrinterBluetoothManager();
  BluetoothManager bluetoothManager = BluetoothManager.instance;
  final devices = [].obs;
  void initPrinter() {
    printerManager.startScan(Duration(seconds: 2));
    printerManager.scanResults.listen((event) {
      devices.value = event;
    });
  }

  List<Map<String, dynamic>> dataDummy = [
    {"title": 'Produk 1', "price": 10000, "qty": 2, "total_price": 20000},
    {"title": 'Produk 2', "price": 20000, "qty": 1, "total_price": 20000},
  ];

  @override
  void onInit() {
    bluetoothManager.state.listen((event) {
      if (event == 12) {
        initPrinter();
      } else {
        Fluttertoast.showToast(msg: "Bluetooth tidak aktif, mohon diaktifkan");
      }
    });
    super.onInit();
  }

  disposeWorker() {
    printerManager.stopScan();
  }

  Future<void> testPrint(PrinterBluetooth device) async {
    printerManager.selectPrinter(device);
    final result =
        await printerManager.printTicket(await ticket(PaperSize.mm80));
    Fluttertoast.showToast(msg: result.msg);
  }

  Future<Ticket> ticket(PaperSize paper) async {
    final ticket = Ticket(paper);
    int total = 0;
    ticket.text("Toko Ku",
        styles: PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size2,
            width: PosTextSize.size2));
    for (int i; i < dataDummy.length; i++) {
      ticket.text(dataDummy[i]['title']);
      total += dataDummy[i]['total_price'];
      ticket.row([
        PosColumn(
            text:
                "${ConvertUtils.formatMoney(dataDummy[i]['price'])} x ${ConvertUtils.formatMoney(dataDummy[i]['qty'])}",
            width: 6),
        PosColumn(
            text: "${ConvertUtils.formatMoney(dataDummy[i]['total_price'])}",
            width: 6),
      ]);
    }
    ticket.feed(1);
    ticket.row([
      PosColumn(text: "Total", width: 6, styles: PosStyles(bold: true)),
      PosColumn(
          text: "Rp ${ConvertUtils.formatMoney(total)}",
          width: 6,
          styles: PosStyles(bold: true)),
    ]);
    ticket.feed(2);
    ticket.text("Terima Kasih",
        styles: PosStyles(align: PosAlign.center, bold: true));
    ticket.cut();
    return ticket;
  }
}
