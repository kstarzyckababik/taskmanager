import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class ToDoTile extends StatelessWidget {
  final String taskName;
  final bool taskCompleted;
  final String taskDescription;
  final DateTime deadline;

  Function(bool?)? onChanged;
  Function(BuildContext)? deleteFunction;
  Function(BuildContext)? editFunction;

  ToDoTile({
    super.key,
    required this.deadline,
    required this.taskName,
    required this.taskCompleted,
    required this.taskDescription,
    required this.onChanged,
    required this.deleteFunction,
    required this.editFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: editFunction,
              icon: Icons.edit,
              backgroundColor: Colors.indigoAccent.shade700,
              borderRadius: BorderRadius.circular(12),
            ),
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red.shade300,
              borderRadius: BorderRadius.circular(12),
            )
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(24), //task name
          decoration: BoxDecoration(
              color: checkDeadlineHighlight(),
              borderRadius: BorderRadius.circular(12)),
          child: Column(children: [
            Row(children: [
              Text(
                DateFormat('dd-MM-yyyy HH:mm').format(deadline),
              )
            ]),
            Row(
              children: [
                Checkbox(
                  value: taskCompleted,
                  onChanged: onChanged,
                  activeColor: Colors.indigoAccent,
                ),
                Text(
                  taskName,
                  style: TextStyle(
                    decoration: taskCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                )
              ],
            ),
            Row(
              children: [
                Text(
                  taskDescription,
                  style: TextStyle(fontSize: 10),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }

  Color checkDeadlineHighlight() {
    if (deadline.difference(DateTime.now()).inMinutes > 0 &&
        deadline.difference(DateTime.now()).inMinutes < 60 &&
        !taskCompleted) {
      return Colors.redAccent;
    } else {
      return Colors.white;
    }
  }
}
