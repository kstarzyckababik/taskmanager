import 'package:flutter/material.dart';
import 'package:taskmanager/util/my_button.dart';

class DialogBox extends StatelessWidget {
  final title_controller;
  final description_controller;
  final Function(DateTime) onDateSelected;

  VoidCallback onSave;
  VoidCallback onCancel;

  DialogBox({
    super.key,
    required this.title_controller,
    required this.description_controller,
    required this.onDateSelected,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Container(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: title_controller,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "Add a new task"),
            ),
            TextField(
              controller: description_controller,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Add optional description"),
            ),
            TextButton(
              onPressed: () => pickDate(context),
              child: Text("Wybierz datę"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MyButton(text: "Save", onPressed: onSave),
                const SizedBox(width: 8),
                MyButton(text: "Cancel", onPressed: onCancel)
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      pickTime(context, pickedDate);
    }
  }

  Future<void> pickTime(BuildContext context, DateTime pickedDate) async {
    final TimeOfDay? pickedHour = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedHour != null) {
      DateTime finalDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedHour.hour,
          pickedHour.minute);

      onDateSelected(finalDateTime);
    }
  }
}
