import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class LocalizationAssetLoader extends AssetLoader {
  final Map<String, dynamic> minRequiredTranslations = {
    "app_title": "Todo App",
    "edit_page_title": "Edit Todo",
    "add_page_title": "Add Todo"
  };
  final Dio _dio = Dio();
  final Connectivity _connectivity = Connectivity();

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    ConnectivityResult connectivityResult =
        await _connectivity.checkConnectivity();
    final appSupportDirectory = await getApplicationSupportDirectory();
    final directory = await appSupportDirectory.create();
    final path = directory.absolute.path;
    String translationsRes;

    switch (locale.languageCode) {
      case 'en':
        File jsonFile = File('$path/en.json');
        bool fileExists = await jsonFile.exists();
        if (fileExists == true) {
          translationsRes = await jsonFile.readAsString();
          return jsonDecode(translationsRes);
        }
        return minRequiredTranslations;
      case 'ja':
        File jsonFile = File('$path/ja.json');
        bool fileExists = await jsonFile.exists();
        if (fileExists == true) {
          translationsRes = await jsonFile.readAsString();
          return jsonDecode(translationsRes);
        }
        return minRequiredTranslations;
      default:
        File jsonFile = File('$path/en.json');
        bool fileExists = await jsonFile.exists();
        if (fileExists == true) {
          translationsRes = await jsonFile.readAsString();
          return jsonDecode(translationsRes);
        }
        return minRequiredTranslations;
    }
  }

  // Future<void> updateTranslationsFromServer() async {
  //   try {
  //     final appSupportDirectory = await getApplicationSupportDirectory();
  //     final directory = await appSupportDirectory.create();
  //     final path = directory.absolute.path;
  //     Map<String, dynamic> translations = {};
  //     var response = await _dio.get('http://192.168.29.202:3000/translations');
  //     translations = response.data;
  //     translations.forEach((key, value) {
  //       File jsonFile = File('$path/$key.json');
  //       jsonFile.writeAsString(jsonEncode(value));
  //     });
  //   } catch (e) {
  //     return;
  //   }
  // }
}
