import 'dart:convert';

const String movieTable = 'movies';
const String genreTable = 'genres';

List<Movie> moviesFromJsonApi(String str) =>
    List<Movie>.from(json.decode(str).map((x) => Movie.fromJsonApi(x)));

String movieToJsonApi(List<Movie> movies) =>
    json.encode(List<dynamic>.from(movies.map((x) => x.toJsonApi())));


class MovieFields {
  static final List<String> values = [
    id,
    name,
    description,
    genre,
    director,
    year
  ];
  static const String id = '_id';
  static const String name = 'name';
  static const String description = 'description';
  static const String genre = 'genre';
  static const String director = 'director';
  static const String year = 'year';
}

class Movie {
  int? id;
  String name;
  String description;
  String genre;
  String director;
  int year;

  Movie(
      {this.id,
      required this.name,
      required this.description,
      required this.genre,
      required this.director,
      required this.year});

  Movie copy({
    int? id,
    String? name,
    String? description,
    String? genre,
    String? director,
    int? year,
  }) =>
      Movie(
          id: id ?? this.id,
          name: name ?? this.name,
          description: description ?? this.description,
          genre: genre ?? this.genre,
          director: director ?? this.director,
          year: year ?? this.year);

  Map<String, Object?> toJson() => {
        MovieFields.id: id,
        MovieFields.name: name,
        MovieFields.description: description,
        MovieFields.director: director,
        MovieFields.genre: genre,
        MovieFields.year: year
      };

  static Movie fromJson(Map<String, Object?> json) => Movie(
      id: json[MovieFields.id] as int?,
      name: json[MovieFields.name] as String,
      description: json[MovieFields.description] as String,
      director: json[MovieFields.director] as String,
      genre: json[MovieFields.genre] as String,
      year: json[MovieFields.year] as int);

  Map<String, dynamic> toJsonApi() => {
        "id": id,
        "name": name,
        "description": description,
        "director": director,
        "genre": genre,
        "year": year,
      };

  factory Movie.fromJsonApi(Map<String, dynamic> json) => Movie(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      director: json['director'],
      genre: json['genre'],
      year: json['year']
      );
}
