import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:movie_app/api/api.dart';
import 'package:movie_app/db/movie_db.dart';
import 'package:movie_app/model/year_object.dart';
import 'package:movie_app/screens/active_year_screen.dart';
import 'package:movie_app/screens/top_genre_screen.dart';

import '../model/movie.dart';
import '../util/messageResponse.dart';

class ReleasePage extends StatefulWidget {
  final bool isOnline;

  ReleasePage(this.isOnline);

  @override
  State<StatefulWidget> createState() => _ReleasePage();
}

class _ReleasePage extends State<ReleasePage> {
  bool online = true;
  bool isLoading = false;

  late StreamSubscription<ConnectivityResult> subscription;

  List<Movie> allMovies = [];
  List<Year> release_years = [];

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
        log("Sync");
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

  getYears() async {
    var years = allMovies.map((element) => element.year).toList();
    var yearCount = Map();
    years.forEach((element) {
      if (!yearCount.containsKey(element)) {
        yearCount[element] = 1;
      } else {
        yearCount[element] += 1;
      }
    });
    print(yearCount.toString());

    yearCount.forEach((key, value) {
      release_years.add(Year(year: key, movieCount: value));
    });

    release_years.sort((b, a) => a.movieCount.compareTo(b.movieCount));

    // map.forEach((k, v) => print("Key : $k, Value : $v"));

    // var sortedByValueMap = Map.fromEntries(
    // map.entries.toList()..sort((e1, e2) => e1.value.compareTo(e2.value)));
  }

  getData() async {
    setState(() => isLoading = true);

    if (online == true) {
      allMovies = await ApiService.instance.getAllMovies();
      getYears();
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Release Year Section"),
      ),
      body: Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                Spacer(),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => YearPage(widget.isOnline)));
                    },
                    child: const Text('View active years')),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => GenrePage(online)));
                    },
                    child: const Text('View top 3 genres'))
              ],
            ))
    );
  }

    @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }
}
