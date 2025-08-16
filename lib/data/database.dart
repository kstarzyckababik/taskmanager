import 'package:hive/hive.dart';

import 'ToDo.dart';

class ToDoDataBase {
  List<ToDo> toDoList = [];

  Box<ToDo> get box => Hive.box<ToDo>('mybox');

  //first time run app
  void createInitialData() {

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

    List<ToDo> finishedTasks = [];
    taskList.forEach((task) {
      if (task.isDone) {
        finishedTasks.add(task);
      }
    });
    
    return finishedTasks;
  }
  

  Future<void> addOrUpdate(int key, ToDo todo) async {
    await box.put(key, todo);
  }

  Future<void> delete(int key) async {
    await box.delete(key);
  }
}
