import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DisasterPage(),
    );
  }
}

class Resource {
  String name;
  int count;

  Resource(this.name, this.count);
}

class Message {
  String text;
  String priority;

  Message(this.text, this.priority);
}

class ReliefLocation {
  String name;
  String details;

  ReliefLocation(this.name, this.details);
}

class DisasterPage extends StatefulWidget {
  @override
  State<DisasterPage> createState() => _DisasterPageState();
}

class _DisasterPageState extends State<DisasterPage> {
  List<Resource> resources = [
    Resource("Boats", 5),
    Resource("Life Jackets", 20),
    Resource("Food Kits", 50),
  ];

  List<Message> messages = [];
  List<ReliefLocation> locations = [
    ReliefLocation("Camp A", "Capacity: 200, Water available"),
    ReliefLocation("Camp B", "Capacity: 100, Medical support"),
  ];

  TextEditingController msgController = TextEditingController();
  TextEditingController priorityController = TextEditingController();

  void addMessage() {
    if (msgController.text.isEmpty) return;
    setState(() {
      messages.add(Message(msgController.text, priorityController.text));
      msgController.clear();
      priorityController.clear();
    });
  }

  void showSwipeInput() {
    TextEditingController loc = TextEditingController();
    TextEditingController desc = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Enter Location"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: loc,
                decoration: InputDecoration(hintText: "Location")),
            TextField(
                controller: desc,
                decoration: InputDecoration(hintText: "Description")),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                messages.add(
                    Message("Location: ${loc.text} - ${desc.text}", "Medium"));
              });
              Navigator.pop(context);
            },
            child: Text("Submit"),
          )
        ],
      ),
    );
  }

  void uploadImage() {
    TextEditingController link = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Upload Image (Link)"),
        content: TextField(
            controller: link,
            decoration: InputDecoration(hintText: "Paste URL")),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                messages.add(Message("Image uploaded: ${link.text}", "Low"));
              });
              Navigator.pop(context);
            },
            child: Text("Upload"),
          )
        ],
      ),
    );
  }

  void sendEmergency() {
    setState(() {
      messages.add(Message("🚨 Emergency Location Sent!", "HIGH"));
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: sendEmergency,
      onHorizontalDragEnd: (_) => showSwipeInput(),
      onLongPress: uploadImage,
      child: Scaffold(
        appBar: AppBar(title: Text("Disaster Management")),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Resources
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Resources",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    ...resources.map((r) => ListTile(
                      title: Text(r.name),
                      trailing: Text("Count: ${r.count}"),
                    )),
                  ],
                ),
              ),

              Divider(),

              // Messages
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextField(
                      controller: msgController,
                      decoration: InputDecoration(labelText: "Message"),
                    ),
                    TextField(
                      controller: priorityController,
                      decoration: InputDecoration(
                          labelText: "Priority (High/Medium/Low)"),
                    ),
                    ElevatedButton(
                      onPressed: addMessage,
                      child: Text("Send Message"),
                    ),
                  ],
                ),
              ),

              Divider(),

              // Message list
              ...messages.map((m) => ListTile(
                title: Text(m.text),
                subtitle: Text("Priority: ${m.priority}"),
                tileColor: m.priority.toUpperCase() == "HIGH"
                    ? Colors.red.shade100
                    : m.priority.toUpperCase() == "MEDIUM"
                    ? Colors.orange.shade100
                    : Colors.green.shade100,
              )),

              Divider(),

              // Relief locations
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Relief Locations",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    ...locations.map((l) => ListTile(
                      title: Text(l.name),
                      subtitle: Text(l.details),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text(l.name),
                            content: Text(l.details),
                          ),
                        );
                      },
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}