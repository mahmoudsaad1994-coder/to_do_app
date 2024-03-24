class TaskModel {
  int? id;
  String? title;
  String? description;
  String? time;
  String? date;
  String? repeat;
  String? status;

  TaskModel({
    this.id,
    required this.repeat,
    required this.time,
    required this.date,
    required this.description,
    required this.title,
     this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'time': time,
      'repeat': repeat,
      'status': status,
    };
  }

  TaskModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    date = json['date'];
    time = json['time'];
    repeat = json['repeat'];
    status = json['status'];
  }
}
