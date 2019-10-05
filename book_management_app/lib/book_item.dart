class BookItem {

  int id;
  String title;
  int currentPage;
  int numPages;
  int timeRead;

  BookItem(this.id, this.title, this.currentPage, this.numPages, this.timeRead);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'currentPage': currentPage,
      'numPages': numPages,
      'timeRead': timeRead,
    };
  }

  BookItem.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    currentPage = map['currentPage'];
    numPages = map['numPages'];
    timeRead = map['timeRead'];
  }

}