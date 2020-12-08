import 'dart:io';

import 'package:dio/dio.dart';
import 'package:wholesale/services/dio_service.dart';
import 'package:wholesale/utils/response_utils.dart';

abstract class TokoTransaksiRepository {
  static Future<Map<String, dynamic>> getTransaksi(
      {int limit = 10, int offset = 0}) async {
    try {
      Dio dio = await DioService.withToken();
      Response response =
          await dio.get("/toko/transaksi?limit=$limit&offset=$offset");
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

  static Future<Map<String, dynamic>> postTransaksi(
      Map<String, dynamic> transaksi) async {
    try {
      Dio dio = await DioService.withToken();
      Response response = await dio.post("/toko/transaksi", data: transaksi);
      Map<String, dynamic> data = Map<String, dynamic>();
      data['statusCode'] = response.statusCode;
      data['data'] = response.data;
      print("data $response");
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
