import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:fitness_app/db/db.dart';
import 'package:fitness_app/screens/fitness_screen.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../api/api.dart';
import '../util/messageResponse.dart';

bool dateSaved = false;

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

  List<String> dates = [];

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
    if (dateSaved == false) {
      FitnessDB.instance.deleteAllDates();
      for (var d in dates) {
        FitnessDB.instance.addDate(d);
      }
      if (dates.isNotEmpty) {
        dateSaved = true;
      }
    }
    getData();
  }

  getData() async {
    setState(() => isLoading = true);
    if (online == true) {
      dates = await ApiService.instance.getDates();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Dates: online"),
      ));
      if (dateSaved == false) {
        syncData();
      }
    } else {
      if (dateSaved == false) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Get offline dates - need to sync"),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Get offline dates - synced"),
        ));
        dates = await FitnessDB.instance.getDates();
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
              itemCount: dates.length,
              itemBuilder: (context, index) {
                return ListTile(
                    title: Text(dates[index]),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  EntryPage(dates[index], online)));
                    });
              }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }
}
