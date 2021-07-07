import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_brain.dart';

class ArchivedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppBrain>(
      builder: (context, Data, child) => ListView.builder(
        itemBuilder: (ctx, index) => Padding(
          padding: const EdgeInsets.all(10.0),
          child: Dismissible(
            onDismissed: (dismissible) {
              Data.deleteFromDatabase(
                  Data.archivedTasks[index].id!, index, 'archivedTasks');
            },
            key: ValueKey(Data.archivedTasks[index].id),
            child: ListTile(
              title: Text(
                Data.archivedTasks[index].title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: CircleAvatar(
                radius: 40,
                child: Text(Data.archivedTasks[index].time),
              ),
              subtitle: Text(Data.archivedTasks[index].date),
              trailing: Icon(
                Icons.archive,
                color: Colors.blue,
              ),
            ),
          ),
        ),
        itemCount: Data.archivedTasks.length,
      ),
    );
  }
}
