import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:movie_app/api/api.dart';
import 'package:movie_app/db/movie_db.dart';
import 'package:movie_app/model/year_object.dart';

import '../model/movie.dart';
import '../util/messageResponse.dart';

class GenrePage extends StatefulWidget {
  final bool isOnline;

  GenrePage(this.isOnline);

  @override
  State<StatefulWidget> createState() => _GenrePage();
}

class _GenrePage extends State<GenrePage> {
  bool online = true;
  bool isLoading = false;

  late StreamSubscription<ConnectivityResult> subscription;

  List<Movie> allMovies = [];
  List<Genre> top_genres = [];

  @override
  void initState() {
    super.initState();

    online = widget.isOnline;

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
        online = true;
        getData();
        // syncData();
      } else {
        online = false;

        // getData();
      }
    });

    Future.delayed(Duration.zero, () {
      getData();
    });
  }

  getGenres() async {
    var genres = allMovies.map((element) => element.genre).toList();
    var genreCount = Map();
    genres.forEach((element) {
      if (!genreCount.containsKey(element)) {
        genreCount[element] = 1;
      } else {
        genreCount[element] += 1;
      }
    });

    genreCount.forEach((key, value) {
      top_genres.add(Genre(genre: key, movieCount: value));
    });

    top_genres.sort((b, a) => a.movieCount.compareTo(b.movieCount));
    top_genres = top_genres.take(3).toList();

    // map.forEach((k, v) => print("Key : $k, Value : $v"));

    // var sortedByValueMap = Map.fromEntries(
    // map.entries.toList()..sort((e1, e2) => e1.value.compareTo(e2.value)));
  }

  getData() async {
    setState(() => isLoading = true);

    if (online == true) {
      allMovies = await ApiService.instance.getAllMovies();
      getGenres();
    } else {
      messageResponse(context, "Not available offline");
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Release Year Section"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: top_genres.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(top_genres[index].genre),
                  subtitle:
                      Text("Movie Count: ${top_genres[index].movieCount}"),
                );
              }),
    );
  }

    @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }
}
