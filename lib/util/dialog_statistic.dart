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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [
                Icon(Icons.bar_chart, color: Colors.indigoAccent, size: 28),
                SizedBox(width: 10),
                Text(
                  "Statistics",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigoAccent,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),


            Text(
              "Number of Finished Tasks",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(finishedTasks.length.toString(), style: TextStyle(fontSize: 14)),
            SizedBox(height: 16),

            Text(
              "Most Productive Day",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(countMostProductiveDay(), style: TextStyle(fontSize: 14)),
            SizedBox(height: 24),


            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onCancel,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "OK",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }


  String countMostProductiveDay() {
    final days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
    Map<int, int> counts = {
      for (int i = 1; i <= 7; i++) i: 0,
    };

    for (var task in finishedTasks) {
      int count = counts[task.finishTime!.weekday]!;
      count++;
      counts[task.finishTime!.weekday] = count;
    }

    if (counts.values.every((c) => c == 0)) {
      return "none";
    }

    int bestDay = counts.entries.reduce(
          (a, b) => a.value >= b.value ? a : b,
    ).key;

    return days[bestDay -1];

  }
}