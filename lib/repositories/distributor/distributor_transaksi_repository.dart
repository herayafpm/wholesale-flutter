import 'dart:io';

import 'package:dio/dio.dart';
import 'package:wholesale/services/dio_service.dart';
import 'package:wholesale/utils/response_utils.dart';

abstract class DistributorTransaksiRepository {
  static Future<Map<String, dynamic>> getTransaksi(
      {int limit = 10, int offset = 0, int toko_id = 0}) async {
    try {
      Dio dio = await DioService.withToken();
      Response response = null;
      if (toko_id == 0) {
        response =
            await dio.get("/distributor/transaksi?limit=$limit&offset=$offset");
      } else {
        response = await dio.get(
            "/distributor/transaksi?limit=$limit&offset=$offset&toko_id=$toko_id");
      }
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
      Response response =
          await dio.post("/distributor/transaksi", data: transaksi);
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

  static Future<Map<String, dynamic>> pelunasanTransaksi(
      Map<String, dynamic> pelunasan) async {
    try {
      Dio dio = await DioService.withToken();
      Response response = await dio.post(
          "/distributor/transaksi/${pelunasan['id']}/pelunasan",
          data: pelunasan);
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
