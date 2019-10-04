class BookItem {

  final int id;
  final String title;
  final int currentPage;
  final int numPages;
  final int timeRead;

  BookItem({this.id, this.title, this.currentPage, this.numPages, this.timeRead});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'currentPage': currentPage,
      'numPages': numPages,
      'timeRead': timeRead,
    };
  }

}