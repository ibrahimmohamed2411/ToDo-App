import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_brain.dart';

class DoneScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppBrain>(
      builder: (context, Data, child) => ListView.builder(
        itemBuilder: (ctx, index) => Padding(
          padding: const EdgeInsets.all(10.0),
          child: Dismissible(
            onDismissed: (dismissible) {
              Data.deleteFromDatabase(
                Data.doneTasks[index].id!,
                index,
                'doneTasks',
              );
            },
            key: ValueKey(Data.doneTasks[index].id),
            child: ListTile(
              title: Text(
                Data.doneTasks[index].title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: CircleAvatar(
                radius: 40,
                child: Text(Data.doneTasks[index].time),
              ),
              subtitle: Text(Data.doneTasks[index].date),
              trailing: Icon(
                Icons.done,
                color: Colors.blue,
              ),
            ),
          ),
        ),
        itemCount: Data.doneTasks.length,
      ),
    );
  }
}
