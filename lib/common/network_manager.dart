import 'dart:convert';

import 'package:flutter/services.dart';

class NetWorkManager {
  // static Future<List<Word>> searchWrod(String word, String category) async {
  //   for (int i = 0; i < word.length; i++) {}
  //   final dio = Dio();

  //   String baseUrl = '';
  //   if (kReleaseMode) {
  //     baseUrl = 'https://wonjongseo-jonggack-company.koyeb.app/';
  //   } else {
  //     baseUrl = 'http://localhost:4000/';
  //   }
  //   // baseUrl = 'https://wonjongseo-jonggack-company.koyeb.app';
  //   String url = '${baseUrl}search';
  //   log('connect to $url');
  //   log('word: $word');

  //   var response = await dio.get(
  //     url,
  //     queryParameters: {
  //       'query': word,
  //     },
  //   );

  //   List<Word> result = [];
  //   List datas = await response.data['data'];

  //   for (int i = 0; i < datas.length; i++) {
  //     Word word = Word.fromMap(datas[i]);
  //     result.add(word);
  //   }

  //   return result;
  // }

  static Future<List> readJsonFromAssets(String path) async {
    try {
      final raw = await rootBundle.loadString(
        path,
      ); // ex) 'assets/data/config.json'
      return jsonDecode(raw) as List<dynamic>;
    } catch (e) {
      print('e.toString() : ${e.toString()}');
      return [];
    }
  }

  static Future<List> getDataToServer(String params) async {
    return await readJsonFromAssets("assets/json/$params.json");

    // final dio = Dio();

    // String baseUrl = '';
    // if (kReleaseMode) {
    //   baseUrl = 'https://wonjongseo-jonggack-company.koyeb.app';
    // } else {
    //   baseUrl = 'http://localhost:4000';
    // }
    // // baseUrl = 'https://wonjongseo-jonggack-company.koyeb.app';
    // log('connect to $baseUrl');
    // log('params: $params');
    // var response = await dio.get(
    //   // 'http://localhost:4000',
    //   baseUrl,
    //   queryParameters: {
    //     // 'data': 'N1-voca',
    //     'data': params,
    //   },
    // );
    // var json = await response.data['data'];

    // return json;
  }
}

//https://wonjongseo-jonggack-company.koyeb.app/?data=N1-voca
