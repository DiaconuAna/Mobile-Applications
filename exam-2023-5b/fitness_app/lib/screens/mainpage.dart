import 'dart:async';
import 'dart:convert';

import 'package:fitness_app/screens/type_screen.dart';
import 'package:fitness_app/screens/week_calories.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../db/db.dart';
import '../util/messageResponse.dart';
import 'main_section.dart';

class MainPage extends StatefulWidget {
  final String _title;
  final IOWebSocketChannel channel =
      IOWebSocketChannel.connect("ws://10.0.2.2:2305");
  MainPage(this._title);
  @override
  State<StatefulWidget> createState() => _MainPage(channel: channel);
}

class _MainPage extends State<MainPage> {
  final WebSocketChannel channel;
  bool online = true;

  late StreamSubscription<ConnectivityResult> subscription;

  _MainPage({required this.channel}) {
    channel.stream.listen((data) {
      var d = jsonDecode(data);
      messageResponse(context, "From socket: " + d['type'] + ' was added!');
    });
  }

  @override
  void initState() {
    super.initState();

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
        online = true;
      } else {
        online = false;
        messageResponse(
            context, "Main: No internet. Local data will be shown.");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget._title)),
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
                              builder: (_) =>
                                  HomePage("Main Section", online)));
                    },
                    child: const Text('Main Section')),
                TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => WeekPage(online)));
                    },
                    child: const Text('Progress Section')),
                TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => TypePage(online)));
                    },
                    child: const Text('Type Section'))
              ],
            )));
  }

  @override
  void dispose() {
    FitnessDB.instance.close();
    super.dispose();
    subscription.cancel();
  }
}
