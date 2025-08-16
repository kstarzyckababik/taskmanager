import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskmanager/pages/home_page.dart';

import 'data/ToDo.dart';

void main() async {



  await Hive.initFlutter();
  Hive.registerAdapter(ToDoAdapter());
  var box = await Hive.openBox<ToDo>('mybox');


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData(primarySwatch: Colors.indigo),
    );
  }
}