import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:todolist_app/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<Todo> todoBox;
  void initState() {
    super.initState();
    todoBox = Hive.box<Todo>("todo");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1d2630),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: Text("Lista de tarefas"),
      ),
      body: ValueListenableBuilder(
        valueListenable: todoBox.listenable(),
        builder: (context, Box<Todo> box, _){
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index){
              Todo todo = box.getAt(index)!;
              return Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: todo.isCompleted ? Colors.white : Colors.white,
                  borderRadius: BorderRadius.circular(10)
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
                  onDismissed: (direction){
                    setState(() {
                      todo.delete();
                    });
                  },
                  child: ListTile(
                    title: Text(todo.title),
                    subtitle: Text(todo.description),
                    trailing: Text(
                      DateFormat.yMMMd().format(todo.dateTime),
                      ),
                      leading: Checkbox(
                        value: todo.isCompleted,
                        onChanged: (value){
                          setState(() {
                            todo.isCompleted = value!;
                            todo.save();
                          });
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
        onPressed: (){
          _addTodoDialog(context);
        },
        child: Icon(Icons.add),
        ),
    );
  }

  void _addTodoDialog(BuildContext context){
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
            onPressed:(){
              Navigator.pop(context);
            },
            child: Text("Cancelar")
          ),
          TextButton(
            onPressed: () {
              _addTodo(_titleController.text, _descController.text);
              Navigator.pop(context);
          }, 
          child: Text("Adicionar"))
        ]
      ),
    );
  }

  void _addTodo(String title, String description){
    if(title.isNotEmpty){
      todoBox.add(
        Todo(title: title,
        description: description,
        dateTime: DateTime.now()
        ),
      );
    }
  }
}