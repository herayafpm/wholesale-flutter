import 'dart:io';

import 'package:dio/dio.dart';
import 'package:wholesale/services/dio_service.dart';
import 'package:wholesale/utils/response_utils.dart';

abstract class DistributorBarangStokRepository {
  static Future<Map<String, dynamic>> getStoks(int id,
      {int limit = 10, int offset = 0, String search = ""}) async {
    try {
      Dio dio = await DioService.withToken();
      Response response = await dio.get(
          "/distributor/barang/$id/riwayatstok?limit=$limit&offset=$offset");
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

  static Future<Map<String, dynamic>> postStok(
      int id, Map<String, dynamic> stok) async {
    try {
      Dio dio = await DioService.withToken();
      Response response =
          await dio.post("/distributor/barang/$id/updatestok", data: stok);
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
