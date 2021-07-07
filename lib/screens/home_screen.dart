import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_brain.dart';
import 'package:todo_app/models/task.dart';

class HomeScreen extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppBrain>(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(provider.titles[provider.currentIndex]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (provider.isButtomSheetShown) {
            provider.addTask(
              Task(
                date: dateController.text,
                title: titleController.text,
                status: 'new',
                time: timeController.text,
              ),
            );
            clearControllers();
            Navigator.of(context).pop();
            provider.changeBottomSheetState(false, Icons.edit);
          } else {
            scaffoldKey.currentState!.showBottomSheet(
              (context) => Form(
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  color: Colors.grey[100],
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: titleController,
                          style: TextStyle(),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.task),
                            labelText: 'Task Title',
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) {
                            if (v!.isEmpty) return 'title must not be empty';
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          onTap: () async {
                            var time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (time != null)
                              timeController.text = time.format(context);
                          },
                          controller: timeController,
                          style: TextStyle(),
                          keyboardType: TextInputType.datetime,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock_clock),
                            labelText: 'Timing tapped',
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) {
                            if (v!.isEmpty) return 'time must not be empty';
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          onTap: () async {
                            var date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2022, 1, 1),
                            );
                            if (date != null) {
                              dateController.text =
                                  '${date.year}-${date.month}-${date.day}';
                            }
                          },
                          controller: dateController,
                          style: TextStyle(),
                          keyboardType: TextInputType.datetime,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.calendar_today),
                            labelText: 'Task Date',
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) {
                            if (v!.isEmpty) return 'date must not be empty';
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
            provider.changeBottomSheetState(true, Icons.add);
          }
        },
        child: Icon(provider.fabIcon),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: provider.currentIndex,
        onTap: (index) {
          provider.changeIndex(index);
        },
        items: [
          BottomNavigationBarItem(
            label: 'Tasks',
            icon: Icon(
              Icons.menu,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Done',
            icon: Icon(
              Icons.check_circle_outline,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Archived',
            icon: Icon(
              Icons.archive_outlined,
            ),
          ),
        ],
      ),
      body: provider.screens[provider.currentIndex],
    );
  }

  void clearControllers() {
    titleController.clear();
    dateController.clear();
    timeController.clear();
  }
}
