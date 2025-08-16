import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:taskmanager/data/database.dart';
import 'package:taskmanager/util/dialog_box.dart';
import 'package:taskmanager/util/dialog_statistic.dart';
import 'package:intl/intl.dart';
import '../data/ToDo.dart';
import '../util/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ToDoDataBase db = ToDoDataBase();
  List<ToDo> taskList = List.empty();

  @override
  void initState() {
    if (db.loadData().isEmpty) {
      db.createInitialData(); // do usuniecie w finalnej wersji
      taskList = db.loadData();
    } else {
      taskList = db.loadData();
    }

    super.initState();
  }
  int selectedIndex = 0;
  final title_controller = TextEditingController();
  final description_controller = TextEditingController();
  DateTime selectedDate = DateTime.now();

  //checkbox
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      ToDo selectedTask = taskList[index];
      
      if( value == null){
        value = false;
      }
      
      if(value == true){
        selectedTask.finishTime = DateTime.now();
      }
      selectedTask.isDone = value!; // ignore null value check if its null above
      
      db.addOrUpdate(selectedTask.id, selectedTask);
    });
  }

  void saveNewTask() {
    setState(() {
      ToDo newTask = ToDo(
          id: generateUniqueId(db.box),
          title: title_controller.text,
          description: description_controller.text,
          isDone: false,
          deadline: selectedDate,
          finishTime: null);

      db.addOrUpdate(newTask.id, newTask);
loadCurrentData(selectedIndex);

      title_controller.clear();
    });

    Navigator.of(context).pop();
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          title_controller: title_controller,
          description_controller: description_controller,
          onDateSelected: (pickedDate) {
            setState(() {
              selectedDate = pickedDate; // aktualizacja w rodzicu
            });
          },
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }


  void openStatisticDialog(){
    showDialog(
      context: context,
      builder: (context) {
        return DialogStatistic( onCancel: () => Navigator.of(context).pop(),finishedTasks: db.loadDataForDoneTasks(),);
      },
    );
  }


  void deleteTask(int index) {
    setState(() {
      List<ToDo> lista = db.loadData();

      ToDo taskToRemove = lista[index];

      db.delete(taskToRemove.id);

    loadCurrentData(selectedIndex);
    });
  }

  void editTask(int index) {
    title_controller.text = taskList[index].title;
    description_controller.text = taskList[index].description;

    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          title_controller: title_controller,
          description_controller: description_controller,
          onDateSelected: (pickedDate) {
            setState(() {
              selectedDate = pickedDate; // aktualizacja w rodzicu
            });
          },
          onSave: () {
            setState(() {
              List<ToDo> lista = db.loadData();
              ToDo taskToEdit = lista[index];

              taskToEdit.title = title_controller.text;
              taskToEdit.description = description_controller.text;
              taskToEdit.deadline = selectedDate;
              ///dodac description i date
              db.addOrUpdate(taskToEdit.id, taskToEdit);
              loadCurrentData(selectedIndex);

              title_controller.clear();
            });
            Navigator.of(context).pop();
          },
          onCancel: () {
            title_controller.clear();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.indigoAccent,
        appBar: AppBar(
          title: Text("Menadżer Zadań Osobistych"),
        ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "btn1",
            onPressed: createNewTask,
            child: Icon(Icons.add),
          ),
          const SizedBox(width: 16), // odstęp
          FloatingActionButton(
            heroTag: "btn2",
            onPressed: openStatisticDialog,
            child: Icon(Icons.stacked_bar_chart),
          ),
        ],
      ),
        body:
      ListView.builder(
        itemCount: taskList.length,
        itemBuilder: (context, index) {
          return ToDoTile(
            taskName: taskList[index].title,
            taskCompleted: taskList[index].isDone,
            taskDescription: taskList[index].description,
            deadline: taskList[index].deadline,
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
            editFunction: (context) => editTask(index),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "All",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done),
            label: "Finished",
          ),
        ],
      ),

    );
  }

  void onTabTapped(int index) {
    setState(() {
      selectedIndex = index;
      loadCurrentData(selectedIndex);
    });
  }


  void loadCurrentData(int tabIndex){
    if(selectedIndex == 0 )// All Tab
        {
      taskList = db.loadData();
    }
    else if (selectedIndex == 1){ //Finished Tab
      taskList = db.loadDataForDoneTasks();
    }
  }
}


int generateUniqueId(Box<ToDo> box) {
  final random = Random();
  int id;
  do {
    id = random.nextInt(1000000);
  } while (box.containsKey(id));
  return id;
}
