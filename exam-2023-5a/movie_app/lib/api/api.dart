import 'package:dio/dio.dart';
import 'dart:developer';

import '../model/movie.dart';

const String baseUrl = 'http://10.0.2.2:2305';

class ApiService {
  static final ApiService instance = ApiService._init();
  static final Dio dio = Dio();

  ApiService._init();

  // genres

  Future<List<String>> getGenres() async {
    log("Server: get genre list");
    const String getUrl = '$baseUrl/genres';

    var response = await dio.get(getUrl,
        options: Options(
          responseType: ResponseType.json,
        ));

    if (response.statusCode == 200) {
      var responseData = response.data as List;
      log("Server: get genre list executed successfully");
      return responseData.map((e) => e.toString()).toList();
    } else {
      log("Server: get genre list failed");
      throw Exception("err");
    }
  }

  // movies

  Future<List<Movie>> getMoviesByGenre(String genre) async {
    log("Server: get movies for genre $genre");
    String getUrl = '$baseUrl/movies/$genre';
    var response = await dio.get(getUrl,
        options: Options(
          responseType: ResponseType.json,
        ));

    if (response.statusCode == 200) {
      log("Server: get movies for genre $genre - successful");
      var responseData = response.data as List;
      //       return responseData.map((e) => Pokemon.fromJsonApi(e)).toList();
      // print(">> " + responseData.toString());
      return responseData.map((e) => Movie.fromJsonApi(e)).toList();
    } else {
      log("Server: get movies for genre $genre");
      throw Exception("err");
    }
  }

  Future<Movie> addMovie(Movie movie) async {
    log("Server: add movie ${movie.name} ");
    var response = await dio.post('$baseUrl/movie', data: movie.toJsonApi());
    if (response.statusCode == 200) {
      log("Server: add movie ${movie.name} - successful");
      return Movie.fromJsonApi(response.data);
    } else {
      log("Server: add movie ${movie.name} - failed");
      throw Exception('err');
    }
  }

  void deleteMovie(int id) async {
    log("Server: delete movie with id $id");
    var response = await dio.delete('$baseUrl/movie/$id');
    log("Server: delete movie $response");
  }

  Future<List<Movie>> getAllMovies() async{
    log("Server: get all movies");
    String getUrl = '$baseUrl/all';
    var response = await dio.get(getUrl,
        options: Options(
          responseType: ResponseType.json,
        ));

    if (response.statusCode == 200) {
      log("Server: get all movies - successful");
      var responseData = response.data as List;
      //       return responseData.map((e) => Pokemon.fromJsonApi(e)).toList();
      // print(">> " + responseData.toString());
      return responseData.map((e) => Movie.fromJsonApi(e)).toList();
    } else {
      log("Server: get all movies - failed");
      throw Exception("err");
    }
  }
}
