import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wholesale/static_data.dart';

class ItemButtonProcess extends StatelessWidget {
  final bool isLoading;
  final Function onTap;
  final String title;

  const ItemButtonProcess(
      {Key key, this.isLoading = false, this.onTap, this.title = ""})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(StaticData.screenWidth, StaticData.screenHeight),
        allowFontScaling: true);
    return Parent(
      child: Center(
        child: (isLoading)
            ? SizedBox(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
                width: 20,
                height: 20,
              )
            : Txt(
                title,
                style: TxtStyle()
                  ..fontSize(16.ssp)
                  ..textColor(Colors.white)
                  ..fontWeight(FontWeight.bold),
              ),
      ),
      gesture: Gestures()..onTap((isLoading) ? null : onTap),
      style: ParentStyle()
        ..height(0.06.sh)
        ..width(0.9.sw)
        ..opacity((!isLoading) ? 1 : 0.8)
        ..background.color(Color(0xFF3A9AD9))
        ..borderRadius(all: 4)
        ..elevation((!isLoading) ? 3 : 0)
        ..ripple(!isLoading, splashColor: Colors.white),
    );
  }
}
