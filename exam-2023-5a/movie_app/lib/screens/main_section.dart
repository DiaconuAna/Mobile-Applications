import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:movie_app/api/api.dart';
import 'package:movie_app/db/movie_db.dart';
import 'package:movie_app/screens/movie_screen.dart';

import '../util/messageResponse.dart';

bool genreSaved = false;

class HomePage extends StatefulWidget {
  final String _title;
  final bool isOnline;
  HomePage(this._title, this.isOnline);

  @override
  State<StatefulWidget> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  bool online = true;
  bool isLoading = false;

  List<String> genres = [];

  late StreamSubscription<ConnectivityResult> subscription;

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
        syncData();
      } else {
        online = false;
        getData();
      }
    });

    Future.delayed(Duration.zero, () {
      getData();
    });
  }

  syncData() async {
    log("genresSaved: ${genreSaved}");
    if (genreSaved == false) {
      MovieDB.instance.deleteAllGenres();
      for (var g in genres) {
        MovieDB.instance.addGenre(g);
      }
      if (genres.isNotEmpty) {
        genreSaved = true;
      }
    }
    getData();
  }

  getData() async {
    setState(() => isLoading = true);
    if (online == true) {
      genres = await ApiService.instance.getGenres();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Genres: online"),
      ));
      if (genreSaved == false) {
        syncData();
      }
    } else {
      if (genreSaved == false) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Get offline genres - need to sync"),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Get offline genres - synced"),
        ));
        genres = await MovieDB.instance.getGenres();
      }
    }
    setState(() => isLoading = false);
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._title),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: genres.length,
              itemBuilder: (context, index) {
                return ListTile(
                    title: Text(genres[index]),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  MoviePage(genres[index], online)));
                    });
              }),
    );
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
