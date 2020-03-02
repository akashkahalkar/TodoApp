import 'package:intl/intl.dart';

class TodoItems {
  bool isCompleted;
  String description;
  String date;

  TodoItems(this.isCompleted, this.description) {
    var currentDate = DateTime.now();
    var formatter = DateFormat.yMMMMd("en_US").add_jm();
    var dateString = formatter.format(currentDate);
    this.date = dateString;
  }
}
