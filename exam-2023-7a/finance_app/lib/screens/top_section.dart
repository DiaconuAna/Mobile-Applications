import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:finance_app/model/statistics_object.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../api/api.dart';
import '../model/entity.dart';
import '../util/messageResponse.dart';

class CategoryPage extends StatefulWidget {
  final bool isOnline;

  CategoryPage(this.isOnline);

  @override
  State<StatefulWidget> createState() => _CategoryPage();
}

class _CategoryPage extends State<CategoryPage> {
  bool online = true;
  bool isLoading = false;

  late StreamSubscription<ConnectivityResult> subscription;

  List<Record> allEntries = [];
  List<Category> topCategories = [];

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

  getTopTips() async {
    var categories = allEntries.map((element) => element.category).toList();
    var categoryCount = Map();
    categories.forEach((element) {
      if (!categoryCount.containsKey(element)) {
        categoryCount[element] = 1;
      } else {
        categoryCount[element] += 1;
      }
    });

    categoryCount.forEach((key, value) {
      topCategories.add(Category(category: key, transactionCount: value));
    });

    topCategories.sort((b, a) => a.transactionCount.compareTo(b.transactionCount));
    topCategories = topCategories.take(3).toList();
  }

  getData() async {
    setState(() => isLoading = true);

    if (online == true) {
      allEntries = await ApiService.instance.getAllEntries();
      getTopTips();
    } else {
      messageResponse(context, "Not available offline");
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Top Section"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: topCategories.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(topCategories[index].category),
                  subtitle: Text("Transaction count: ${topCategories[index].transactionCount}"),
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
