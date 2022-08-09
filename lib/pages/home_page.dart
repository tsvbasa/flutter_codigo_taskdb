import 'package:flutter/material.dart';
import 'package:flutter_codigo_taskdb/db/db_admin.dart';
import 'package:flutter_codigo_taskdb/models/task_model.dart';
import 'package:flutter_codigo_taskdb/widgets/my_form_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TaskModel? task;

  showDialogForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MyFormWidget(
          model: task,
        );
      },
    ).then((value) {
      // print("El formulario fue cerrado");
      setState(() {});
    });
  }

  deleteTask(int taskId) {
    DBAdmin.db.deleteTask(taskId).then((value) {
      if (value > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.indigo,
            content: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Tarea eliminada",
                ),
              ],
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          task = null;
          showDialogForm();
        },
        child: Icon(
          Icons.add,
        ),
      ),
      body: FutureBuilder(
        future: DBAdmin.db.getTasks(),
        builder: (
          BuildContext context,
          AsyncSnapshot asyncSnapshot,
        ) {
          if (asyncSnapshot.hasData) {
            List<TaskModel> myTasks = asyncSnapshot.data;
            return ListView.builder(
                itemCount: myTasks.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    // key: Key(index.toString()),
                    key: UniqueKey(),
                    confirmDismiss: (DismissDirection direction) async {
                      return true;
                    },
                    direction: DismissDirection.horizontal,
                    background: Container(
                      color: Colors.purpleAccent,
                    ),
                    // secondaryBackground: Container(
                    //   color: Colors.blueAccent,
                    // ),
                    onDismissed: (DismissDirection direction) {
                      deleteTask(myTasks[index].id!);
                    },
                    child: ListTile(
                      trailing: IconButton(
                        onPressed: () {
                          task = myTasks[index];
                          showDialogForm();
                        },
                        icon: Icon(Icons.edit),
                      ),
                      title: Text(myTasks[index].title),
                      subtitle: Text(myTasks[index].description),
                    ),
                  );
                });
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
