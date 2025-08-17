import 'package:hive/hive.dart';

import 'ToDo.dart';

class ToDoDataBase {
  List<ToDo> toDoList = [];

  Box<ToDo> get box => Hive.box<ToDo>('mybox');


  void createInitialData() {    //first time run app  - for test test
     var obj1 = ToDo(
          id: 1,
          title: "title",
          description: "description",
          isDone: false,
          deadline: DateTime.now(),
          finishTime: null);

     var obj2 = ToDo(
         id: 2,
         title: "title",
         description: "description",
         isDone: false,
         deadline: DateTime.now(),
          finishTime: null);
     addOrUpdate(obj1.id, obj1);
     addOrUpdate(obj2.id, obj2);

  }

  Future<void> clearDatabase() async {
    await box.clear();
  }

  List<ToDo> loadData() {
    List<ToDo> list = box.values.toList();
    list.sort((a, b) => a.deadline.compareTo(b.deadline));
    return list;
  }
  
  List<ToDo> loadDataForDoneTasks(){
    List<ToDo> taskList = box.values.toList();
    taskList.sort((a, b) => a.deadline.compareTo(b.deadline));

    List<ToDo> finishedTasks = [];
    taskList.forEach((task) {
      if (task.isDone) {
        finishedTasks.add(task);
      }
    });
    
    return finishedTasks;
  }

  List<ToDo> loadDataForUnDoneTasks(){
    List<ToDo> taskList = box.values.toList();
    taskList.sort((a, b) => a.deadline.compareTo(b.deadline));

    List<ToDo> unDoneTasks = [];
    taskList.forEach((task) {
      if (!task.isDone) {
        unDoneTasks.add(task);
      }
    });

    return unDoneTasks;
  }

  Future<void> addOrUpdate(int key, ToDo todo) async {
    await box.put(key, todo);
  }

  Future<void> delete(int key) async {
    await box.delete(key);
  }
}
