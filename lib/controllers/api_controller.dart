import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import '../models/coffee_model.dart';

class ApiController extends GetxController {
  final String baseUrl = 'https://my-coffeeshop-api.bagusromadhon007.workers.dev';
  var httpTime = 0.0.obs;
  var dioTime = 0.0.obs;
  var coffees = <Coffee>[].obs;
  final Dio dio = Dio();

  Future<void> fetchWithHttp() async {
    final stopwatch = Stopwatch()..start();
    try {
      final res = await http.get(Uri.parse('$baseUrl/api/v1/menu'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as List;
        coffees.value = data.map((e) => Coffee.fromJson(e)).toList();
      }
    } catch (e) {
      print('HTTP Error: $e');
    } finally {
      stopwatch.stop();
      httpTime.value = stopwatch.elapsedMilliseconds / 1000;
    }
  }

  Future<void> fetchWithHttpBroken() async {
    final sw = Stopwatch()..start();
    try {
      // sengaja akses path yg gak ada → 404
      final res = await http.get(Uri.parse('$baseUrl/api/v1/not-exist'));
      if (res.statusCode >= 400) {
        throw Exception('HTTP ${res.statusCode}: ${res.body}');
      }
    } catch (e) {
      // bukti: http perlu manual try-catch
      print('HTTP Error (expected): $e');
    } finally {
      sw.stop();
      httpTime.value = sw.elapsedMilliseconds / 1000;
    }
  }



  // Versi 1: async–await (lebih readable)
  Future<Map<String, dynamic>> chainWithAsyncAwait() async {
    final menuRes = await dio.get('$baseUrl/api/v1/menu');
    final list = (menuRes.data as List);
    if (list.isEmpty) throw Exception('Menu kosong');
    final first = list.first as Map<String, dynamic>;
    final orderRes = await dio.post('$baseUrl/api/v1/order', data: {
      'items': [
        {'id': first['id'], 'qty': 1}
      ],
      'note': 'async-await chain'
    });
    return orderRes.data as Map<String, dynamic>;
  }

  // Versi 2: callback chaining (then...then...catchError)
  Future<void> chainWithCallbacks(
    void Function(Map<String, dynamic>) onDone,
    void Function(Object) onError,
  ) async {
    dio.get('$baseUrl/api/v1/menu')
      .then((menuRes) {
        final list = (menuRes.data as List);
        if (list.isEmpty) throw Exception('Menu kosong');
        final first = list.first as Map<String, dynamic>;
        return dio.post('$baseUrl/api/v1/order', data: {
          'items': [
            {'id': first['id'], 'qty': 1}
          ],
          'note': 'callback chain'
        });
      })
      .then((orderRes) => onDone(orderRes.data as Map<String, dynamic>))
      .catchError(onError);
  }



  Future<void> fetchWithDio() async {
    final stopwatch = Stopwatch()..start();
    // dio.interceptors.add(LogInterceptor(
    //   request: true, requestBody: false,
    //   responseBody: true, error: true,
    // ));
    try {
      final res = await dio.get('$baseUrl/api/v1/menu');
      final data = res.data as List;
      coffees.value = data.map((e) => Coffee.fromJson(e)).toList();
    } catch (e) {
      print('Dio Error: $e');
    } finally {
      stopwatch.stop();
      dioTime.value = stopwatch.elapsedMilliseconds / 1000;
    }
  }
}
