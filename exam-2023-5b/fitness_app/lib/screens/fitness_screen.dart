// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:fitness_app/db/db.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../api/api.dart';
import '../model/entry.dart';
import '../util/messageResponse.dart';
import 'add_screen.dart';

List<String> dateSaved = [];

class EntryPage extends StatefulWidget {
  final String date;
  final bool isOnline;

  EntryPage(this.date, this.isOnline);

  @override
  State<StatefulWidget> createState() => _EntryPage();
}

class _EntryPage extends State<EntryPage> {
  bool online = true;

  late String date;

  bool isLoading = false;
  List<Entry> entriesPerdate = [];
  bool saved = false;

  late StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {
    super.initState();
    online = widget.isOnline;
    date = widget.date;
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
    final genres = entriesPerdate.where((element) => element == widget.date);
    return genres.isEmpty;
  }

  getData() async {
    setState(() => isLoading = true);
    if (online == true) {
      entriesPerdate = await ApiService.instance.getEntriesByDate(date);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Back at it!"),
      ));
      syncData();
    } else {
      if (checkSaved() == false) {
        entriesPerdate = await FitnessDB.instance.getBydate(date);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Offline entries"),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Entries have not been saved yet to db"),
        ));
      }
    }
    setState(() => isLoading = false);
  }

  syncData() async {
    log("Syncing >> ${checkSaved()}");
    if (checkSaved()) {
      FitnessDB.instance.deleteAllEntriesBydate(date);
      // sync data and add category to list
      for (var entry in entriesPerdate) {
        FitnessDB.instance.addEntry(entry);
      }
      dateSaved.add(date);
    }
  }

  void addEntry(Entry entry) async {
    setState(() => isLoading = true);
    if (online) {
      final Entry newEntry = await ApiService.instance.addEntry(entry);
      setState(() {
        entriesPerdate.add(newEntry);
      });
      FitnessDB.instance.addEntry(newEntry);
    }
    setState(() => isLoading = false);
  }

  void deleteEntryBack(Entry entry) async {
    setState(() => isLoading = true);
    if (online) {
      setState(() {
        ApiService.instance.deleteEntry(entry.id!);
        entriesPerdate.remove(entry);
        Navigator.pop(context);
        FitnessDB.instance.deleteEntry(entry.id!);
      });
    }
    setState(() => isLoading = false);
  }

  void deleteEntry(BuildContext context, Entry entry) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("Delete Entry"),
              content:
                  Text("Are you sure you want to delete entry: ${entry.type}?"),
              actions: [
                TextButton(
                    onPressed: () {
                      deleteEntryBack(entry);
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
        title: Text("Entries for $date"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: entriesPerdate.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(entriesPerdate[index].type),
                  subtitle: Text(getEntryDetails(entriesPerdate[index])),
                  onTap: () {},
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    color: Colors.amber,
                    onPressed: () {
                      if (online) {
                        deleteEntry(context, entriesPerdate[index]);
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
                    MaterialPageRoute(builder: (_) => AddPage(widget.date)))
                .then((newEntry) {
              if (newEntry != null) {
                setState(() {
                  addEntry(newEntry);
                });
              }
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Cannot add while offline"),
            ));
          }
        },
        tooltip: "Add Entry",
        child: Icon(Icons.add),
      ),
    );
  }

  String getEntryDetails(Entry e) {
    // date duration distance calories rate
    return "Duration: ${e.duration}\nDistance: ${e.distance}\nCalories: ${e.calories}\nRate: ${e.rate}";
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }
}
