import 'package:blue_thermal_printer/blue_thermal_printer.dart';
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
                child: Obx(
                  () => ListView.builder(
                    itemCount: controller.deviceBluetooths.length,
                    itemBuilder: (BuildContext context, int index) {
                      BluetoothDevice device =
                          controller.deviceBluetooths[index];
                      return ListTile(
                        tileColor: Colors.white,
                        title: Text(device.name),
                        onTap: () {
                          controller.itemOnTap(device);
                        },
                      );
                    },
                  ),
                ),
              )),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 50),
            child: Obx(
              () => RaisedButton(
                  onPressed:
                      controller.connected.value ? controller.tesPrint : null,
                  child: Text('TesPrint')),
            ),
          ),
        ],
      ),
    );
  }
}
