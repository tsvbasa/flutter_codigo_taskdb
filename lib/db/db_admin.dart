import 'dart:io';
import 'package:flutter_codigo_taskdb/models/task_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DBAdmin {
  Database? myDatabase;

  //Singleton
  static final DBAdmin db = DBAdmin._();
  DBAdmin._();
  //

  Future<Database?> checkDatabase() async {
    if (myDatabase != null) {
      return myDatabase;
    }
    myDatabase = await initDatabase(); //Crear base de datos
    return myDatabase;
  }

  Future<Database> initDatabase() async {
    Directory directory =
        await getApplicationDocumentsDirectory(); //obtiene la ruta dinamica donde esta instalado en el dispositivo
    String path = join(directory.path, "TaskBD.db");
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database dbx, int version) async {
        //Crear la tabla correspondiente
        await dbx.execute(
            "CREATE TABLE TASK(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, status TEXT)");
      },
    );
  }

  Future<int> insertRawTask(TaskModel model) async {
    Database? db = await checkDatabase();
    int res = await db!.rawInsert(
        "INSERT INTO TASK(title, description, status) VALUES ('${model.title}','${model.status}','${model.status.toString()}')");
    return res;
  }

  Future<int> insertTask(TaskModel model) async {
    Database? db = await checkDatabase();
    int res = await db!.insert(
      "TASK",
      {
        "title": model.title,
        "description": model.description,
        "status": model.status,
      },
    );
    print(res);
    return res;
  }

  Future<List<TaskModel>> getRawTask(int id) async{
    Database? db = await checkDatabase();
    List<Map<String,dynamic>> tasks = await db!.rawQuery("SELECT * FROM Task WHERE id = $id");
    List<TaskModel> task = tasks.map((e) => TaskModel.fromJson(e)).toList();
    return task;
  }

  getRawTasks() async{
    Database? db = await checkDatabase();
    List tasks = await db!.rawQuery("SELECT * FROM Task");
    print(tasks);
  }

  Future<List<TaskModel>> getTasks() async{
    Database? db = await checkDatabase();
    List<Map<String, dynamic>> tasks = await db!.query("Task");
    List<TaskModel> taskModelList = tasks.map((e) => TaskModel.fromJson(e)).toList();
    // tasks.forEach((element) {
    //   TaskModel task = TaskModel.fromJson(element);
    //   taskModelList.add(task);
    // });
    return taskModelList;
  }
  
  updateRawTasks() async{
    Database? db = await checkDatabase();
    int res = await db!.rawUpdate("UPDATE TASK SET title = 'Ir de compras', description = 'Comprar comida', status = 'true' WHERE id = 2");
    print(res);
  }

  Future<int> updateTask(TaskModel model) async{
    Database? db = await checkDatabase();
    int res = await db!.update(
        "TASK",
        {
          "title": model.title,
          "description": model.description,
          "status": model.status,
        },
        where: "id = ${model.id}"
    );
    return res;
  }
  // updateTasks() async{
  //   Database? db = await checkDatabase();
  //   int res = await db!.update(
  //     "TASK",
  //     {
  //       "title": "Ir al cine",
  //       "description": "Es el viernes en la tarde",
  //       "status": "false",
  //     },
  //     where: "id = 2"
  //   );
  // }

  deleteRawTask() async{
    Database? db = await checkDatabase();
    int res = await db!.rawDelete("DELETE FROM TASK WHERE id = 4");
    print(res);
  }

  Future<int> deleteTask(int id) async{
    Database? db = await checkDatabase();
    int res = await db!.delete("TASK", where: "id = $id");
    return res;
  }

}
