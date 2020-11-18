import 'package:division/division.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wholesale/static_data.dart';

class ItemPickerComp extends StatelessWidget {
  final String text;
  final String title;
  final Function onTap;

  const ItemPickerComp({Key key, this.title = "judul", this.text, this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(StaticData.screenWidth, StaticData.screenHeight),
        allowFontScaling: true);
    return Parent(
      gesture: Gestures()..onTap(onTap),
      style: ParentStyle()
        ..border(all: 2, color: Colors.white)
        ..borderRadius(all: 4)
        ..padding(vertical: 6, horizontal: 4)
        ..height(0.08.sh)
        ..width(1.sw)
        ..padding(left: 10)
        ..ripple(true, splashColor: Colors.blueAccent),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Txt(text,
              style: TxtStyle()
                ..alignment.centerLeft()
                ..fontSize(15.ssp)
                ..textColor(Colors.white)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.expand_more,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
