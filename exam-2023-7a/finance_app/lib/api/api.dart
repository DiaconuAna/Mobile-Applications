import 'package:dio/dio.dart';
import 'dart:developer';

import '../model/entity.dart';

const String baseUrl = 'http://10.0.2.2:2307';

class ApiService {
  static final ApiService instance = ApiService._init();
  static final Dio dio = Dio();

  ApiService._init();

  // date

  Future<List<String>> getDays() async {
    log("Server: get day list");
    const String getUrl = '$baseUrl/days';

    var response = await dio.get(getUrl,
        options: Options(
          responseType: ResponseType.json,
        ));

    if (response.statusCode == 200) {
      var responseData = response.data as List;
      log("Server: get days list executed successfully");
      return responseData.map((e) => e.toString()).toList();
    } else {
      log("Server: get days list failed");
      throw Exception("err");
    }
  }

  // records

  Future<List<Record>> getTransactionsByDate(String date) async {
    log("Server: get transactions for date $date");
    String getUrl = '$baseUrl/transactions/$date';
    var response = await dio.get(getUrl,
        options: Options(
          responseType: ResponseType.json,
        ));

    if (response.statusCode == 200) {
      log("Server: get transactions for date $date - successful");
      var responseData = response.data as List;
      //       return responseData.map((e) => Pokemon.fromJsonApi(e)).toList();
      // print(">> " + responseData.toString());
      return responseData.map((e) => Record.fromJsonApi(e)).toList();
    } else {
      log("Server: get transactions for date $date - failed");
      throw Exception("err");
    }
  }

  Future<List<Record>> getAllEntries() async {
    log("Server: get entry list");
    const String getUrl = '$baseUrl/entries';

    var response = await dio.get(getUrl,
        options: Options(
          responseType: ResponseType.json,
        ));

    if (response.statusCode == 200) {
      var responseData = response.data as List;
      log("Server: get entry list executed successfully");
      return responseData.map((e) => Record.fromJsonApi(e)).toList();
    } else {
      log("Server: get entry list failed");
      throw Exception("err");
    }
  }

  // Future<Entry> addEntry(Entry entry) async {
  //   log("Server: add entry " + entry.toString());
  //   var response = await dio.post('$baseUrl/entry', data: entry.toJsonApi());
  //   log("added?");
  //   if (response.statusCode == 200) {
  //     log("Server: add entry ${entry.type} - successful");
  //     return Entry.fromJsonApi(response.data);
  //   } else {
  //     log("Server: add entry ${entry.type} - failed");
  //     throw Exception('err');
  //   }
  // }

  // void deleteEntry(int id) async {
  //   log("Server: delete entry with id $id");
  //   var response = await dio.delete('$baseUrl/entry/$id');
  //   log("Server: delete entry $response");
  // }
}
