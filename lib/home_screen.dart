import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist_app/task_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TaskProvider taskProvider = Provider.of<TaskProvider>(context);
    return Scaffold(
      backgroundColor: Color(0xFF1d2630),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: Text("Lista de tarefas"),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, _) {
          return ListView.builder(
            itemCount: taskProvider.tasks.length,
            itemBuilder: (context, index) {
              final todo = taskProvider.tasks[index];
              return Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: todo.isCompleted ? Colors.white : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Dismissible(
                  key: Key(todo.dateTime.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) {
                    taskProvider.removeTask(index);
                  },
                  child: ListTile(
                    title: Text(todo.title),
                    subtitle: Text(todo.description),
                    trailing: Text(todo.dateTime.toString()),
                    leading: Checkbox(
                      value: todo.isCompleted,
                      onChanged: (value) {
                        final updatedTodo = Todo(
                          title: todo.title,
                          description: todo.description,
                          dateTime: todo.dateTime,
                          isCompleted: value!,
                        );
                        taskProvider.updateTask(index, updatedTodo);
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTodoDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _addTodoDialog(BuildContext context) {
    TextEditingController _titleController = TextEditingController();
    TextEditingController _descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Adicionar tarefa"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: "Título"),
            ),
            TextField(
              controller: _descController,
              decoration: InputDecoration(labelText: "Descricao"),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancelar")),
          TextButton(
              onPressed: () {
                _addTodo(_titleController.text, _descController.text, context);
                Navigator.pop(context);
              },
              child: Text("Adicionar"))
        ],
      ),
    );
  }

  void _addTodo(String title, String description, BuildContext context) {
    if (title.isNotEmpty) {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      taskProvider.addTask(
        Todo(
          title: title,
          description: description,
          dateTime: DateTime.now(),
        ),
      );
    }
  }
}
