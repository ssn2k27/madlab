import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoPage(),
    );
  }
}

class Task {
  String id;
  String title;
  bool isDone;

  Task(this.title, {this.isDone = false})
      : id = DateTime.now().millisecondsSinceEpoch.toString();
}

class TodoPage extends StatefulWidget {
  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  List<Task> tasks = [];
  TextEditingController controller = TextEditingController();

  void addTask() {
    if (controller.text.trim().isEmpty) return;
    setState(() {
      tasks.add(Task(controller.text.trim()));
      controller.clear();
    });
  }

  void toggleDone(int index) {
    setState(() {
      tasks[index].isDone = !tasks[index].isDone;
    });
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Todo App")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "Enter task",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: addTask,
                  child: Text("Add"),
                )
              ],
            ),
          ),
          Expanded(
            child: ReorderableListView.builder(
              itemCount: tasks.length,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex--;
                  final item = tasks.removeAt(oldIndex);
                  tasks.insert(newIndex, item);
                });
              },
              itemBuilder: (context, index) {
                final task = tasks[index];

                return Dismissible(
                  key: ValueKey(task.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => deleteTask(index),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  child: AnimatedOpacity(
                    key: ValueKey("tile_${task.id}"),
                    duration: Duration(milliseconds: 300),
                    opacity: task.isDone ? 0.3 : 1.0,
                    child: ListTile(
                      tileColor: Colors.grey.shade200,
                      leading: Checkbox(
                        value: task.isDone,
                        onChanged: (_) => toggleDone(index),
                      ),
                      title: Text(
                        task.title,
                        style: TextStyle(
                          decoration: task.isDone
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}