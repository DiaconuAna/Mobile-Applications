import 'package:personal_library/book.dart';
import 'package:flutter/material.dart';

//Image.network('https://picsum.photos/250?image=9')

class BookDetails extends StatefulWidget {
  final Book _book;

  BookDetails(this._book);

  @override
  State<StatefulWidget> createState() => _BookDetails();
}

class _BookDetails extends State<BookDetails> {
  @override
  void initState() {
    Book currentBook = widget._book;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget._book.title),
        ),
        body: Card(
          elevation: 4.0,
          child: Column(
            children: [
              ListTile(
                title: Text("TITLE: " + widget._book.title),
                subtitle: Text("AUTHOR: " + widget._book.author),
              ),
              if (Uri.parse(widget._book.imageUrl).isAbsolute)
                Container(
                  height: 200.0,
                  child:
                      Image.network(widget._book.imageUrl, fit: BoxFit.cover),
                ),
              Container(
                padding: EdgeInsets.all(16.0),
                alignment: Alignment.centerLeft,
                child: Text(widget._book.description),
              ),
            ],
          ),
        ));
  }
}
