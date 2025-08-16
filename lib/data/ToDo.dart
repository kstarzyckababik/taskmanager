import 'package:hive/hive.dart';

part 'ToDo.g.dart';

@HiveType(typeId: 0)
class ToDo extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  bool isDone;

  @HiveField(4)
  DateTime deadline;
  
  @HiveField(5)
  DateTime? finishTime;

  ToDo(
      {required this.id,
      required this.title,
      required this.description,
      required this.isDone,
      required this.deadline,
      required this.finishTime});
}
