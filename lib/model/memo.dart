class Memo {
  final String id;
  final String title;
  final String text;
  final String createdTime;
  final String editedTime;

  Memo({
    required this.id,
    required this.title,
    required this.text,
    required this.createdTime,
    required this.editedTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'text': text,
      'createdTime': createdTime,
      'editedTime': editedTime,
    };
  }

  @override
  String toString() {
    return 'Memo(id:$id, title:$title, text:$text, createdTime:$createdTime, editedTime:$editedTime)';
  }
}
