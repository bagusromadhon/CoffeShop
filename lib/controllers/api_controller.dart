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

  Future<void> fetchWithDio() async {
    final stopwatch = Stopwatch()..start();
    dio.interceptors.add(LogInterceptor(
      request: true, requestBody: false,
      responseBody: true, error: true,
    ));
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
