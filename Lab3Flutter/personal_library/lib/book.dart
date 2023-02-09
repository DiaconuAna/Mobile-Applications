class Book {
  static int id = 2;
  var bid;
  var title;
  var author;
  var genre;
  var description;
  var pageNumber;
  var quotes;
  var review;
  var imageUrl;

  Book.b1(
      {this.bid,
      this.title,
      this.author,
      this.genre,
      this.description,
      this.pageNumber,
      this.imageUrl});
  Book(
      {this.bid,
      this.title,
      this.author,
      this.genre,
      this.description,
      this.pageNumber,
      this.quotes,
      this.review,
      this.imageUrl});
}

/**
 * Card buildCard() {
   var heading = '\$2300 per month';
   var subheading = '2 bed, 1 bath, 1300 sqft';
   var cardImage = NetworkImage(
       'https://source.unsplash.com/random/800x600?house');
   var supportingText =
       'Beautiful home to rent, recently refurbished with modern appliances...';
   return Card(
       elevation: 4.0,
       child: Column(
         children: [
           ListTile(
             title: Text(heading),
             subtitle: Text(subheading),
             trailing: Icon(Icons.favorite_outline),
           ),
           Container(
             height: 200.0,
             child: Ink.image(
               image: cardImage,
               fit: BoxFit.cover,
             ),
           ),
           Container(
             padding: EdgeInsets.all(16.0),
             alignment: Alignment.centerLeft,
             child: Text(supportingText),
           ),
           ButtonBar(
             children: [
               TextButton(
                 child: const Text('CONTACT AGENT'),
                 onPressed: () {/* ... */},
               ),
               TextButton(
                 child: const Text('LEARN MORE'),
                 onPressed: () {/* ... */},
               )
             ],
           )
         ],
       ));
 }
 */