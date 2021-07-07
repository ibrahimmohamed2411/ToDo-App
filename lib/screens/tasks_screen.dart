import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_brain.dart';

class TasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<AppBrain>(context, listen: false).getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());
        if (snapshot.hasError) return Center(child: Text('Error'));
        if (snapshot.hasData)
          return Consumer<AppBrain>(
            builder: (context, Data, child) => ListView.builder(
              itemBuilder: (ctx, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  title: Text(
                    Data.newTasks[index].title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: CircleAvatar(
                    radius: 30,
                    child: FittedBox(child: Text(Data.newTasks[index].time)),
                  ),
                  subtitle: Text(Data.newTasks[index].date),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () async {
                          await Data.update(
                              index, 'done', Data.newTasks[index].id!);
                        },
                        icon: Icon(
                          Icons.check_box,
                          color: Colors.green,
                          size: 30,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await Data.update(
                              index, 'archived', Data.newTasks[index].id!);
                        },
                        icon: Icon(
                          Icons.archive,
                          color: Colors.black45,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              itemCount: Data.newTasks.length,
            ),
          );
        return Text('UnExpected Error');
      },
    );
  }
}
