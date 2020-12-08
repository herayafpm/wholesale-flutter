import 'dart:io';

import 'package:dio/dio.dart';
import 'package:wholesale/services/dio_service.dart';
import 'package:wholesale/utils/response_utils.dart';

abstract class TokoBarangRepository {
  static Future<Map<String, dynamic>> getBarangs(
      {int limit = 10, int offset = 0, String search = ""}) async {
    try {
      Dio dio = await DioService.withToken();
      Response response = await dio
          .get("/toko/barang?limit=$limit&offset=$offset&search=$search");
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

  static Future<Map<String, dynamic>> getBarang(int id) async {
    try {
      Dio dio = await DioService.withToken();
      Response response = await dio.get("/toko/barang/$id");
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

  static Future<Map<String, dynamic>> putBarang(
      int id, Map<String, dynamic> barang) async {
    try {
      Dio dio = await DioService.withToken();
      Response response = await dio.put("/toko/barang/$id", data: barang);
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

  static Future<Map<String, dynamic>> deleteBarang(int id) async {
    try {
      Dio dio = await DioService.withToken();
      Response response = await dio.delete("/toko/barang/$id");
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
