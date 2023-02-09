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

class YearPage extends StatefulWidget {
  final bool isOnline;

  YearPage(this.isOnline);

  @override
  State<StatefulWidget> createState() => _YearPage();
}

class _YearPage extends State<YearPage> {
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
    /**
     *  var elements = ["a", "b", "c", "d", "e", "a", "b", "c", "f", "g", "h", "h", "h", "e"];
  var map = Map();

  elements.forEach((element) {
    if(!map.containsKey(element)) {
      map[element] = 1;
    } else {
      map[element] += 1;
    }
  });

  print(map);
     */
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
              itemCount: release_years.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(release_years[index].year.toString()),
                  subtitle:
                      Text("Movie Count: ${release_years[index].movieCount}"),
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
