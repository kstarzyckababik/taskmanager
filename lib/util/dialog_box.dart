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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //
            Row(
              children: [
                Icon(Icons.task_alt, color: Colors.indigoAccent, size: 28),
                SizedBox(width: 10),
                Text(
                  "New Task",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigoAccent,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            //
            TextField(
              controller: title_controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                hintText: "Add a new task",
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
            SizedBox(height: 12),

            // Opis
            TextField(
              controller: description_controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                hintText: "Add optional description",
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 12),

            //
            TextButton.icon(
              onPressed: () => pickDate(context),
              icon: Icon(Icons.calendar_today, color: Colors.indigoAccent),
              label: Text(
                "Select deadline",
                style: TextStyle(color: Colors.indigoAccent),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            SizedBox(height: 16),

            //
            TextButton(
              onPressed: onSave,
              style: TextButton.styleFrom(
                backgroundColor: Colors.indigoAccent,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 12),

            //
            TextButton(
              onPressed: onCancel,
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.black),
              ),
            ),
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
