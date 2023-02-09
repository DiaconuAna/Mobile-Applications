// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:finance_app/db/db.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../api/api.dart';
import '../model/entity.dart';
import '../util/messageResponse.dart';

List<String> dateSaved = [];

class RecordPage extends StatefulWidget {
  final String date;
  final bool isOnline;

  RecordPage(this.date, this.isOnline);

  @override
  State<StatefulWidget> createState() => _RecordPage();
}

class _RecordPage extends State<RecordPage> {
  bool online = true;

  late String date;

  bool isLoading = false;
  List<Record> recordsPerDate = [];
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

    Future.delayed(Duration.zero, () {
      getData();
    });
  }

  bool checkSaved() {
    final genres = recordsPerDate.where((element) => element == widget.date);
    return genres.isEmpty;
  }

  getData() async {
    setState(() => isLoading = true);
    if (online == true) {
      recordsPerDate = await ApiService.instance.getTransactionsByDate(date);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Back at it!"),
      ));
      syncData();
    } else {
      if (checkSaved() == false) {
        recordsPerDate = await EntityDB.instance.getBydate(date);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Offline transactions"),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Transactions have not been saved yet to db"),
        ));
      }
    }
    setState(() => isLoading = false);
  }

  syncData() async {
    log("Syncing >> ${checkSaved()}");
    if (checkSaved()) {
      EntityDB.instance.deleteAllRecordsBydate(date);
      // sync data and add category to list
      for (var transaction in recordsPerDate) {
        EntityDB.instance.addRecord(transaction);
      }
      dateSaved.add(date);
    }
  }

  // void addEntry(Entry entry) async {
  //   setState(() => isLoading = true);
  //   if (online) {
  //     final Entry newEntry = await ApiService.instance.addEntry(entry);
  //     setState(() {
  //       entriesPerdate.add(newEntry);
  //     });
  //     FitnessDB.instance.addEntry(newEntry);
  //   }
  //   setState(() => isLoading = false);
  // }

  // void deleteEntryBack(Entry entry) async {
  //   setState(() => isLoading = true);
  //   if (online) {
  //     setState(() {
  //       ApiService.instance.deleteEntry(entry.id!);
  //       entriesPerdate.remove(entry);
  //       Navigator.pop(context);
  //       FitnessDB.instance.deleteEntry(entry.id!);
  //     });
  //   }
  //   setState(() => isLoading = false);
  // }

  // void deleteEntry(BuildContext context, Entry entry) {
  //   showDialog(
  //       context: context,
  //       builder: (_) => AlertDialog(
  //             title: Text("Delete Entry"),
  //             content:
  //                 Text("Are you sure you want to delete entry: ${entry.type}?"),
  //             actions: [
  //               TextButton(
  //                   onPressed: () {
  //                     deleteEntryBack(entry);
  //                   },
  //                   child: Text("Yes", style: TextStyle(color: Colors.red))),
  //               TextButton(
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                   },
  //                   child: Text("No", style: TextStyle(color: Colors.green)))
  //             ],
  //           ));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transactions for $date"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: recordsPerDate.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(recordsPerDate[index].type),
                  subtitle: Text(getRecordDetails(recordsPerDate[index])),
                  onTap: () {},
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    color: Colors.amber,
                    onPressed: () {
                      // if (online) {
                      //   deleteEntry(context, entriesPerdate[index]);
                      //   //(context, tipsPerCategory[index]);
                      // } else {
                      //   ScaffoldMessenger.of(context)
                      //       .showSnackBar(const SnackBar(
                      //     content: Text("Cannot delete while offline"),
                      //   ));
                      // }
                    },
                  ),
                );
              }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (online) {
            // Navigator.push(context,
            //         MaterialPageRoute(builder: (_) => AddPage(widget.date)))
            //     .then((newEntry) {
            //   if (newEntry != null) {
            //     setState(() {
            //       addEntry(newEntry);
            //     });
            //   }
            // });
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

  String getRecordDetails(Record r) {
    return "Amount: ${r.amount}\nCategory: ${r.category}\nDescription: ${r.description}";
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }
}
