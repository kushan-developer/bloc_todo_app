import 'dart:convert';

import 'package:bloc_todo_app/data/models/todo.dart';

import 'package:bloc_todo_app/data/services/api_result.dart';
import 'package:bloc_todo_app/data/services/network_exceptions.dart';
import 'package:dio/dio.dart';

import 'package:bloc_todo_app/constants/constants.dart';
import 'package:bloc_todo_app/data/services/dio_client.dart';

class LocaleRepository {
  late DioClient dioClient;
  late final String _baseUrl = apiBase;

  LocaleRepository() {
    var dio = Dio();
    dioClient = DioClient(_baseUrl, dio);
  }

  Future<ApiResult<Map<String, dynamic>>> fetchTranslations() async {
    try {
      final response = await dioClient.get("/translations");
      Map<String, dynamic> localeResponse = response;
      return ApiResult.success(data: localeResponse);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
}
