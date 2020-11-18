import 'dart:io';

import 'package:dio/dio.dart';
import 'package:wholesale/services/dio_service.dart';
import 'package:wholesale/utils/response_utils.dart';

abstract class TokoRepository {
  static Future<Map<String, dynamic>> getToko() async {
    try {
      Dio dio = await DioService.withToken();
      Response response = await dio.get("/toko");
      Map<String, dynamic> data = Map<String, dynamic>();
      data['statusCode'] = response.statusCode;
      data['data'] = response.data;
      return data;
    } on SocketException catch (e) {
      print(e);
      return ResponseUtils.error(e.message);
    } on DioError catch (e) {
      print(e);
      return ResponseUtils.error(e.message);
    } catch (e) {
      print(e);
      return ResponseUtils.error(e.message);
    }
  }

  static Future<Map<String, dynamic>> updateToko(
      Map<String, dynamic> toko) async {
    try {
      Dio dio = await DioService.withToken();
      Response response = await dio.put("/toko", data: toko);
      Map<String, dynamic> data = Map<String, dynamic>();
      data['statusCode'] = response.statusCode;
      data['data'] = response.data;
      return data;
    } on SocketException catch (e) {
      print(e);
      return ResponseUtils.error(e.message);
    } on DioError catch (e) {
      print(e);
      return ResponseUtils.error(e.message);
    } catch (e) {
      print(e);
      return ResponseUtils.error(e.message);
    }
  }
}
