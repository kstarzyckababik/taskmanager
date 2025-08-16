import 'package:flutter/material.dart';
import 'package:taskmanager/util/my_button.dart';

import '../data/ToDo.dart';

class DialogStatistic extends StatelessWidget {

  VoidCallback onCancel;
  List<ToDo> finishedTasks;

  DialogStatistic({
    super.key, required this.onCancel, required this.finishedTasks});


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Container(
        height: 150,
        child: Column(
            children: [
              Text("Number of Done tasks: " + finishedTasks.length.toString()),
              Text("Most productive day: " + countMostProductiveDay()),
              Spacer(),
              MyButton(text: "Cancel", onPressed: onCancel)
            ]
        ),
      ),
    );
  }

  String countMostProductiveDay() {
    final days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
    Map<int, int> counts = {
      for (int i = 1; i <= 7; i++) i: 0, // weekday: count
    };

    for (var task in finishedTasks) {
      int count = counts[task.finishTime!.weekday]!;
      count++;
      counts[task.finishTime!.weekday] = count;
    }

    int bestDay = counts.entries.reduce(
          (a, b) => a.value >= b.value ? a : b,
    ).key;

    return days[bestDay -1];

  }
}