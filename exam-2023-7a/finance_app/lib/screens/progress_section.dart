import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:finance_app/model/statistics_object.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../api/api.dart';
import '../model/entity.dart';
import '../util/messageResponse.dart';

import 'package:week_of_year/week_of_year.dart';
import 'package:intl/intl.dart';

class WeekPage extends StatefulWidget {
  final bool isOnline;

  WeekPage(this.isOnline);

  @override
  State<StatefulWidget> createState() => _WeekPage();
}

class _WeekPage extends State<WeekPage> {
  bool online = true;
  bool isLoading = false;

  late StreamSubscription<ConnectivityResult> subscription;

  List<Record> allRecords = [];
  List<Week> weeks = [];

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

  getWeeks() async {
    var weeklyAmount = Map();
    allRecords.sort((a, b) => a.date.compareTo(b.date));
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    for (var d in allRecords) {
      DateTime dateTime = dateFormat.parse(d.date);
      int weekNumber = dateTime.weekOfYear;
      log("week of year for ${d.date} ${dateTime.weekOfYear}");

      if (!weeklyAmount.containsKey(weekNumber)) {
        weeklyAmount[weekNumber] = d.amount;
      } else {
        weeklyAmount[weekNumber] += d.amount;
      }
    }

    weeklyAmount.forEach((key, value) {
      weeks.add(Week(weekNumber: key, amount: value));
    });
  }

  getData() async {
    setState(() => isLoading = true);

    if (online == true) {
      allRecords = await ApiService.instance.getAllEntries();
      getWeeks();
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
              itemCount: weeks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                      'Week ${weeks[index].weekNumber}'),
                  subtitle: Text("Amount: ${weeks[index].amount}"),
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
