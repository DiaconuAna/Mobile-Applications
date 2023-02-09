import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:movie_app/api/api.dart';
import 'package:movie_app/db/movie_db.dart';
import 'package:movie_app/screens/add_screen.dart';

import '../model/movie.dart';
import '../util/messageResponse.dart';

List<String> moviesPerGenreSaved = [];

class MoviePage extends StatefulWidget {
  final String genre;
  final bool isOnline;

  MoviePage(this.genre, this.isOnline);

  @override
  State<StatefulWidget> createState() => _MoviePage();
}

class _MoviePage extends State<MoviePage> {
  bool online = true;

  late String genre;

  bool isLoading = false;
  List<Movie> moviesPerGenre = [];
  bool saved = false;

  late StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {
    super.initState();
    online = widget.isOnline;
    genre = widget.genre;
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
        online = true;
        getData();
      } else {
        online = false;
        getData();
      }
    });

    //connection();
    Future.delayed(Duration.zero, () {
      getData();
    });
  }

  bool checkSaved() {
    final genres =
        moviesPerGenreSaved.where((element) => element == widget.genre);
    return genres.isEmpty;
  }

  getData() async {
    setState(() => isLoading = true);
    if (online == true) {
      moviesPerGenre = await ApiService.instance.getMoviesByGenre(genre);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Back at it!"),
      ));
      syncData();
    } else {
      if (checkSaved() == false) {
        moviesPerGenre = await MovieDB.instance.getByGenre(genre);
        // tipsPerCategory = await TipDB.instance.getByCategory(category);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Offline tips"),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Tips have not been saved yet to db"),
        ));
      }
    }
    setState(() => isLoading = false);
  }

  syncData() async {
    log("Syncing >> ${checkSaved()}");
    if (checkSaved()) {
      MovieDB.instance.deleteAllMoviesByGenre(genre);
      // sync data and add category to list
      for (var movie in moviesPerGenre) {
        MovieDB.instance.addMovie(movie);
      }
      moviesPerGenreSaved.add(genre);
    }
  }

  void deleteMovieBack(Movie movie) async {
    setState(() => isLoading = true);
    if (online) {
      setState(() {
        ApiService.instance.deleteMovie(movie.id!);
        moviesPerGenre.remove(movie);
        Navigator.pop(context);
        MovieDB.instance.deleteMovie(movie.id!);
      });
    }
    setState(() => isLoading = false);
  }

  void addMovie(Movie movie) async {
    setState(() => isLoading = true);
    if (online) {
      final Movie newMovie = await ApiService.instance.addMovie(movie);
      setState(() {
        moviesPerGenre.add(newMovie);
      });
      MovieDB.instance.addMovie(newMovie);
    }
    setState(() => isLoading = false);
  }

  void deleteMovie(BuildContext context, Movie movie) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("Delete Movie"),
              content:
                  Text("Are you sure you want to delete movie: ${movie.name}?"),
              actions: [
                TextButton(
                    onPressed: () {
                      deleteMovieBack(movie);
                    },
                    child: Text("Yes", style: TextStyle(color: Colors.red))),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("No", style: TextStyle(color: Colors.green)))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Movies for $genre"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: moviesPerGenre.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(moviesPerGenre[index].name),
                  subtitle: Text(getMovieDetails(moviesPerGenre[index])),
                  onTap: () {},
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    color: Colors.amber,
                    onPressed: () {
                      if (online) {
                        deleteMovie(context, moviesPerGenre[index]);
                        //(context, tipsPerCategory[index]);
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Cannot delete while offline"),
                        ));
                      }
                    },
                  ),
                );
              }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (online) {
            Navigator.push(context,
                    MaterialPageRoute(builder: (_) => AddPage(widget.genre)))
                .then((newMovie) {
              if (newMovie != null) {
                setState(() {
                  addMovie(newMovie);
                });
              }
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Cannot add while offline"),
            ));
          }
        },
        tooltip: "Add Tip",
        child: Icon(Icons.add),
      ),
    );
  }

  String getMovieDetails(Movie m) {
    return "Genre: ${m.genre}\nDescription: ${m.description}\nDirector: ${m.director}\nYear: ${m.year}";
  }

  @override
  void dispose() {
    // _networkConnectivity.myStream.listen((event) {}).pause();
    // _networkConnectivity.disposeStream();
    // TipDB.instance.close();
    super.dispose();
    subscription.cancel();
  }
}
