import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:todo_app/helpers/db_helper.dart';
import 'package:todo_app/screens/archived_screen.dart';
import 'package:todo_app/screens/done_screen.dart';
import 'package:todo_app/screens/tasks_screen.dart';

import 'models/task.dart';

class AppBrain extends ChangeNotifier {
  bool _isButtomSheetShown = false;
  IconData _fabIcon = Icons.edit;
  int _currentIndex = 0;
  List<Widget> _screens = [
    TasksScreen(),
    DoneScreen(),
    ArchivedScreen(),
  ];
  List<String> _titles = [
    'New Tasks',
    'Done Tasks',
    'Archived',
  ];
  List<Task> _newTasks = [];
  List<Task> _doneTasks = [];
  List<Task> _archivedTasks = [];
  int get currentIndex => _currentIndex;

  bool get isButtomSheetShown => _isButtomSheetShown;

  List<Widget> get screens => _screens;
  List<String> get titles => _titles;
  void changeIndex(int value) {
    _currentIndex = value;
    notifyListeners();
  }

  List<Task> get newTasks => _newTasks;

  void addTask(Task task) async {
    // title TEXT,date TEXT,time TEXT,status TEXT)',
    int id = await DBHelper.insertToDatabase(
      'tasks',
      {
        'title': task.title,
        'date': task.date,
        'time': task.time,
        'status': task.status,
      },
    );
    task.id = id;
    _newTasks.add(task);
    notifyListeners();
  }

  Future<List<Task>> getData() async {
    _doneTasks = [];
    _newTasks = [];
    _archivedTasks = [];
    List<Task> list = await DBHelper.getDataFromDatabase();
    list.forEach((element) {
      if (element.status == 'done')
        _doneTasks.add(element);
      else if (element.status == 'archived')
        _archivedTasks.add(element);
      else
        _newTasks.add(element);
    });
    return _newTasks;
  }

  void changeBottomSheetState(bool isShow, IconData icon) {
    _isButtomSheetShown = isShow;
    _fabIcon = icon;
    notifyListeners();
  }

  Future<void> update(int index, String status, int id) async {
    switch (status) {
      case 'done':
        _newTasks[index].status = status;
        _doneTasks.add(_newTasks[index]);
        _newTasks.removeAt(index);
        break;
      case 'archived':
        _newTasks[index].status = status;
        _archivedTasks.add(_newTasks[index]);
        _newTasks.removeAt(index);
        break;
    }
    await DBHelper.updateData(status: status, id: id);
    notifyListeners();
  }

  Future<void> deleteFromDatabase(int id, int index, String matrixType) async {
    switch (matrixType) {
      case 'doneTasks':
        _doneTasks.removeAt(index);
        break;
      case 'archivedTasks':
        _archivedTasks.removeAt(index);
        break;
    }

    await DBHelper.deleteData(id);
    notifyListeners();
  }

  IconData get fabIcon => _fabIcon;

  List<Task> get doneTasks => _doneTasks;

  List<Task> get archivedTasks => _archivedTasks;
}
