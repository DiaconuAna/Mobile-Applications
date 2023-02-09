import 'package:flutter/material.dart';
import 'package:personal_library/add_book.dart';

import 'package:personal_library/book.dart';
import 'package:personal_library/book_details.dart';
import 'package:personal_library/message_text.dart';
import 'package:personal_library/update_book.dart';

class BooksHomePage extends StatefulWidget {
  final String _title;
  BooksHomePage(this._title);
  @override
  State<StatefulWidget> createState() => _BooksHomePage();
}

class _BooksHomePage extends State<BooksHomePage> {
  List<Book> books = [
    Book(
      bid: 1,
      title: "Fresh water for flowers",
      author: "Valerie Perrin",
      genre: "Fiction",
      description: "Description",
      pageNumber: 561,
      quotes: "No",
      review: "No",
      imageUrl:
          "http://www.europaeditions.com/spool/cover_9781609455958__id1831_w600_t1590149040__1x.jpg",
    ),
    Book(
      bid: 2,
      title: "Invisible Life of Addie LaRue",
      author: "V.E.Schwab",
      genre: "Fiction, Magical Realism",
      description: "Description",
      pageNumber: 566,
      quotes: "No",
      review: "No",
      imageUrl: "https://cdn.dc5.ro/img-prod/1569035345-0.jpeg",
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget._title)),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          return InkWell(
              child: ListTile(
                  // leading: Image.network(books[index].imageUrl),
                  title: Text(books[index].title),
                  subtitle: Text(books[index].author),
                  hoverColor: Color.fromARGB(255, 216, 147, 251),
                  onTap: () {},
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => UpdateBook(
                                        books[index].title,
                                        books[index].author,
                                        books[index].pageNumber.toString(),
                                        books[index].genre,
                                        books[index].description,
                                        books[index].quotes,
                                        books[index].review,
                                        books[index].imageUrl,
                                      ))).then((newBook) {
                            if (newBook != null) {
                              setState(() {
                                books.removeAt(index);
                                books.insert(index, newBook);
                                messageText(
                                    context,
                                    newBook.title +
                                        " was successfully updated");
                              });
                            }
                          });
                        },
                        icon: Icon(Icons.edit, color: Colors.amberAccent),
                      ),
                      IconButton(
                        onPressed: () {
                          deleteBook(
                              context, books[index].bid, books[index].title);
                        },
                        icon: Icon(Icons.delete, color: Colors.amber),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => BookDetails(books[index])));
                            BookDetails(books[index]);
                          },
                          icon: Icon(Icons.info, color: Colors.amber))
                    ],
                  )));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => AddBook()))
              .then((newBook) {
            if (newBook != null) {
              setState(() {
                books.add(newBook);
                messageText(context,
                    newBook.title + " was added successfully to the list");
              });
            }
          });
        },
        tooltip: "Add book",
        child: Icon(Icons.add),
      ),
    );
  }

  deleteBook(BuildContext context, int bookId, String bookTitle) {
    // messageText(context, "Preparing to delete book with id: " + bookId.toString());
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("Delete book " + bookTitle),
              content:
                  Text("Are you sure you want to delete " + bookTitle + "?"),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      Book bookToRemove =
                          books.firstWhere((book) => book.bid == bookId);
                      this.books.remove(bookToRemove);
                      Navigator.pop(context);
                    });
                  },
                  child: Text(
                    "Proceed",
                    style: TextStyle(color: Colors.purple),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child:
                        Text("Abort", style: TextStyle(color: Colors.indigo)))
              ],
            ));
  }
}
