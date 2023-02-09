import 'package:personal_library/book.dart';

import 'text_box.dart';
import 'package:flutter/material.dart';

class AddBook extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddBook();
}

class _AddBook extends State<AddBook> {
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
    controllerTitle = new TextEditingController();
    controllerAuthor = new TextEditingController();
    controllerDescr = new TextEditingController();
    controllerGenre = new TextEditingController();
    controllerPageNumber = new TextEditingController();
    controllerReview = new TextEditingController();
    controllerQuotes = new TextEditingController();
    controllerImage = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add a book"),
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
                  // if (!Uri.parse(image).isAbsolute) {
                  //   invalidMessage += "\nInvalid URL";
                  // }

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
                            imageUrl: image));
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
                                      this.controllerTitle.text = "";
                                    }
                                    if (invalidMessage.contains("author")) {
                                      this.controllerAuthor.text = "";
                                    }
                                    if (invalidMessage
                                        .contains("page number")) {
                                      this.controllerPageNumber.text = "";
                                    }
                                    if (invalidMessage
                                        .contains("description")) {
                                      this.controllerDescr.text = "";
                                    }
                                    if (invalidMessage.contains("genre")) {
                                      this.controllerGenre.text = "";
                                    }
                                    if (invalidMessage.contains("URL")) {
                                      this.controllerImage.text = "";
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
                child: Text("Add book"))
          ],
        ));
  }
}
