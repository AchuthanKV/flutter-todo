class Todo{
  int id;
  String title;
  bool completed;
  bool reminder;
  DateTime time;

  Todo({
    this.title,
    this.time,
    this.reminder = false,
    this.completed = false,
  });

  Todo.fromMap(Map<String, dynamic> map) :
    title = map['title'],
    time = map['time'],
    reminder = map['reminder'],
    completed = map['completed'];

  updateTitle(title){
    this.title = title;
  }

  initializeTime() {
    this.time = DateTime.now();
  }

  Map toMap(){
    return {
      'title': title,
      'time': time,
      'reminder': reminder,
      'completed': completed,
    };
  }
}