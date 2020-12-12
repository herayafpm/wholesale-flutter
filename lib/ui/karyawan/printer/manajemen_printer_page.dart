import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wholesale/controllers/manajemen_printer_controller.dart';
import 'package:wholesale/static_data.dart';

class ManajemenPrinterPage extends StatelessWidget {
  final controller = Get.put(ManajemenPrinterController());
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    controller.initPrinter();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(StaticData.screenWidth, StaticData.screenHeight),
        allowFontScaling: true);
    return Container(
      width: 1.sw,
      height: 1.sh,
      child: Column(
        children: <Widget>[
          Flexible(
              flex: 1,
              child: SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                header: WaterDropMaterialHeader(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                onRefresh: _onRefresh,
                onLoading: null,
                child: Obx(() => ListView.builder(
                      itemCount: controller.devices.length,
                      itemBuilder: (BuildContext context, int index) {
                        PrinterBluetooth device = controller.devices[index];
                        return ListTile(
                          onTap: () {
                            controller.testPrint(device);
                          },
                          title: Text(device.name),
                          subtitle: Text(device.address),
                          leading: Icon(Icons.print),
                          tileColor: Colors.white,
                        );
                      },
                    )),
              )),
        ],
      ),
    );
  }
}
