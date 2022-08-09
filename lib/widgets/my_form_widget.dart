import 'package:flutter/material.dart';
import 'package:flutter_codigo_taskdb/db/db_admin.dart';
import 'package:flutter_codigo_taskdb/models/task_model.dart';

class MyFormWidget extends StatefulWidget {
  TaskModel? model;

  MyFormWidget({this.model});

  @override
  State<MyFormWidget> createState() => _MyFormWidgetState();
}

class _MyFormWidgetState extends State<MyFormWidget> {
  final _formKey = GlobalKey<FormState>();
  bool isFinished = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  initState() {
    super.initState();
    if (widget.model != null) {
      _titleController.text = widget.model!.title;
      _descriptionController.text = widget.model!.description;
      isFinished = widget.model!.status == "true";
    }
  }

  addTask() {
    if (_formKey.currentState!.validate()) {
      TaskModel taskModel = TaskModel(
        title: _titleController.text,
        description: _descriptionController.text,
        status: isFinished.toString(),
      );
      DBAdmin.db.insertTask(taskModel).then((value) {
        if (value > 0) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.indigo,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              duration: Duration(milliseconds: 1200),
              content: Row(
                children: const [
                  Icon(
                    Icons.check_circle,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Tarea registrada con éxito",
                  ),
                ],
              ),
            ),
          );
        }
      });
    }
  }

  updateTask() {
    if (_formKey.currentState!.validate()) {
      TaskModel taskModel = TaskModel(
        title: _titleController.text,
        description: _descriptionController.text,
        status: isFinished.toString(),
      );
      if (widget.model == null) {
        DBAdmin.db.insertTask(taskModel).then((value) {
          if (value > 0) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.indigo,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                duration: Duration(milliseconds: 1200),
                content: Row(
                  children: const [
                    Icon(
                      Icons.check_circle,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Tarea registrada con éxito",
                    ),
                  ],
                ),
              ),
            );
          }
        });
      } else {
        taskModel.id = widget.model!.id; //Repasar
        DBAdmin.db.updateTask(taskModel).then((value) {
          if (value > 0) {
            Navigator.pop(context);
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
                      "Tarea actualizada",
                    ),
                  ],
                ),
              ),
            );
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Agregar tarea"), //cambiar cuando se edite
            const SizedBox(
              height: 6,
            ),
            TextFormField(
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "El campo es obligatorio";
                }
                if (value.length < 6) {
                  return "Debe de tener min 6 caracteres";
                }
                return null;
              },
              controller: _titleController, //cambiar
              decoration: InputDecoration(
                hintText: "Título",
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            TextFormField(
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "El campo es obligatorio";
                }
                return null;
              },
              controller: _descriptionController, //cambiar
              maxLines: 2,
              decoration: InputDecoration(
                hintText: "Descripción",
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Row(
              children: [
                Text("Estado: "),
                const SizedBox(
                  width: 6,
                ),
                Checkbox(
                  value: isFinished,
                  onChanged: (value) {
                    isFinished = value!;
                    setState(() {});
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancelar"),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    // addTask();
                    updateTask();
                  },
                  child: Text("Aceptar"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
