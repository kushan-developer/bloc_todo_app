import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:bloc_todo_app/constants/constants.dart';
import 'package:bloc_todo_app/constants/enums.dart';
import 'package:bloc_todo_app/data/repositories/locale_repository.dart';
import 'package:bloc_todo_app/data/services/api_result.dart';
import 'package:bloc_todo_app/data/services/dio_client.dart';
import 'package:bloc_todo_app/data/services/network_exceptions.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show Locale;
import 'package:path_provider/path_provider.dart';

part 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  final LocaleRepository localeRepository;
  LocaleCubit({required this.localeRepository})
      : super(const LocaleState(status: Status.initial, locale: Locale('en')));

  Future<bool> updateTranslationsFromServer() async {
    emit(state.copyWith(status: Status.loading));
    final appSupportDirectory = await getApplicationSupportDirectory();
    final directory = await appSupportDirectory.create();
    final path = directory.absolute.path;
    Map<String, dynamic> translations = {};
    ApiResult<Map<String, dynamic>> localeResponse =
        await localeRepository.fetchTranslations();
    bool res =
        localeResponse.when(success: (Map<String, dynamic> translations) {
      translations.forEach((key, value) {
        File jsonFile = File('$path/$key.json');
        jsonFile.writeAsString(jsonEncode(value));
      });
      emit(state.copyWith(status: Status.success));
      return true;
    }, failure: (NetworkExceptions error) {
      emit(state.copyWith(
          status: Status.failure,
          error: NetworkExceptions.getErrorMessage(error)));
      return false;
    });
    return res;
  }

  void updateLocale(Locale locale) {
    emit(state.copyWith(locale: locale, status: Status.updateSuccess));
  }
}
