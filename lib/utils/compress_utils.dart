import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

abstract class CompressUtils {
  static Future<Uint8List> image({Uint8List list, int quality = 100}) async {
    double fileSize = list.length / 1024;
    if (fileSize < 2048) {
      return list;
    } else {
      var result = await FlutterImageCompress.compressWithList(
        list,
        minHeight: 1024,
        minWidth: 780,
        quality: 100,
      );
      print("data ${result.length / 1024}");
      if ((result.length / 1024) < 2048) {
        return result;
      } else {
        image(list: result, quality: quality - 1);
      }
    }
    return list;
  }
}
