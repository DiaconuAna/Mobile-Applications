import 'package:personal_library/book.dart';

import 'text_box.dart';
import 'package:flutter/material.dart';

class UpdateBook extends StatefulWidget {
  final String _title;
  final String _author;
  final String _pageNumber;
  final String _genre;
  final String _description;
  final String _quotes;
  final String _review;
  final String _image;

  UpdateBook(this._title, this._author, this._pageNumber, this._genre,
      this._description, this._quotes, this._review, this._image);
  @override
  State<StatefulWidget> createState() => _UpdateBook();
}

class _UpdateBook extends State<UpdateBook> {
  late TextEditingController controllerTitle;
  late TextEditingController controllerAuthor;
  late TextEditingController controllerDescr;
  late TextEditingController controllerGenre;
  late TextEditingController controllerPageNumber;
  late TextEditingController controllerReview;
  late TextEditingController controllerQuotes;
  late TextEditingController controllerImage;

  @override
  void initState() {
    controllerTitle = new TextEditingController(text: widget._title);
    controllerAuthor = new TextEditingController(text: widget._author);
    controllerDescr = new TextEditingController(text: widget._description);
    controllerGenre = new TextEditingController(text: widget._genre);
    controllerPageNumber = new TextEditingController(text: widget._pageNumber);
    controllerReview = new TextEditingController(text: widget._review);
    controllerQuotes = new TextEditingController(text: widget._quotes);
    controllerImage = new TextEditingController(text: widget._image);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Update a book"),
        ),
        body: ListView(
          children: [
            TextBox(controllerTitle, "Title"),
            TextBox(controllerAuthor, "Author"),
            TextBox(controllerPageNumber, "Number of Pages"),
            TextBox(controllerGenre, "Genre"),
            TextBox(controllerDescr, "Description"),
            TextBox(controllerReview, "Review"),
            TextBox(controllerQuotes, "Quotes"),
            TextBox(controllerImage, "Image URL (optional)"),
            ElevatedButton(
                onPressed: () {
                  String title = controllerTitle.text;
                  String author = controllerAuthor.text;
                  String pageNumber = controllerPageNumber.text;
                  String genre = controllerGenre.text;
                  String description = controllerDescr.text;
                  String review = controllerReview.text;
                  String quotes = controllerQuotes.text;
                  String image = controllerImage.text;

                  String invalidMessage = "";

                  if (title.isEmpty) {
                    invalidMessage += "\nEmpty title";
                  }
                  if (author.isEmpty) {
                    invalidMessage += "\nEmpty author";
                  }
                  if (genre.isEmpty) {
                    invalidMessage += "\nEmpty genre";
                  }
                  if (description.isEmpty) {
                    invalidMessage += "\nEmpty description";
                  }
                  if (int.tryParse(pageNumber) == null ||
                      (int.parse(pageNumber) <= 0)) {
                    invalidMessage += "\nInvalid page number";
                  }
                  if (!Uri.parse(image).isAbsolute) {
                    invalidMessage += "\nInvalid URL";
                  }

                  if (invalidMessage == "") {
                    Navigator.pop(
                        context,
                        new Book(
                            bid: ++Book.id,
                            title: title,
                            author: author,
                            pageNumber: pageNumber,
                            genre: genre,
                            description: description,
                            review: review,
                            quotes: quotes,
                            imageUrl: image
                            ));
                  } else {
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              title: Text("Invalid add"),
                              content: Text(invalidMessage),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    if (invalidMessage.contains("title")) {
                                      this.controllerTitle.text = widget._title;
                                    }
                                    if (invalidMessage.contains("author")) {
                                      this.controllerAuthor.text =
                                          widget._author;
                                    }
                                    if (invalidMessage.contains("page")) {
                                      this.controllerPageNumber.text =
                                          widget._pageNumber;
                                    }
                                    if (invalidMessage
                                        .contains("description")) {
                                      this.controllerDescr.text =
                                          widget._description;
                                    }
                                    if (invalidMessage.contains("genre")) {
                                      this.controllerGenre.text = widget._genre;
                                    }
                                    if (invalidMessage.contains("URL")) {
                                      this.controllerImage.text = widget._image;
                                    }
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Try again",
                                    style: TextStyle(color: Colors.purple),
                                  ),
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: Text("Abort",
                                        style: TextStyle(color: Colors.indigo)))
                              ],
                            ));
                  }
                },
                child: Text("Update book"))
          ],
        ));
  }
}
