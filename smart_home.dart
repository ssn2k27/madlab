import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ServiceScreen(),
    );
  }
}

class ServiceScreen extends StatefulWidget {
  @override
  _ServiceScreenState createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  Map<String, Map<String, dynamic>> services = {
    "Cleaning": {"price": 200, "rating": 4.5},
    "Plumbing": {"price": 500, "rating": 4.2},
    "Electrician": {"price": 400, "rating": 4.3},
    "Painting": {"price": 1000, "rating": 4.6},
    "AC Repair": {"price": 800, "rating": 4.4},
  };

  Map<String, bool> selected = {};

  DateTime? selectedDate;
  String timeSlot = "Morning";

  String status = "Pending";

  int get total {
    int sum = 0;
    selected.forEach((key, value) {
      if (value) sum += services[key]!["price"] as int;
    });
    return sum;
  }

  void placeOrder() {
    if (selected.values.every((v) => !v) || selectedDate == null) return;

    setState(() {
      status = "Confirmed";
    });

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        status = "Completed";
      });
    });
  }

  void pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Smart Home Services")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // 🛠️ Services List
            ...services.keys.map((service) {
              return Card(
                child: CheckboxListTile(
                  title: Text(service),
                  subtitle: Text(
                      "₹${services[service]!["price"]} | ⭐ ${services[service]!["rating"]}"),
                  value: selected[service] ?? false,
                  onChanged: (val) {
                    setState(() {
                      selected[service] = val!;
                    });
                  },
                ),
              );
            }),

            SizedBox(height: 10),

            // 📅 Date Picker
            ElevatedButton(
              onPressed: pickDate,
              child: Text(selectedDate == null
                  ? "Select Date"
                  : selectedDate.toString().split(" ")[0]),
            ),

            SizedBox(height: 10),

            // ⏰ Time Slot
            DropdownButton(
              value: timeSlot,
              items: ["Morning", "Afternoon", "Evening"]
                  .map((e) =>
                  DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  timeSlot = val.toString();
                });
              },
            ),

            SizedBox(height: 20),

            // 💰 Total Bill
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text("Total Bill",
                        style: TextStyle(fontSize: 18)),
                    Text("₹$total",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // 📦 Status
            Text("Status: $status",
                style: TextStyle(
                    fontSize: 18,
                    color: status == "Completed"
                        ? Colors.green
                        : Colors.orange)),

            SizedBox(height: 20),

            // 🚀 Place Order Button
            ElevatedButton(
              onPressed: placeOrder,
              child: Text("Place Order"),
            ),

            SizedBox(height: 20),

            // 🧾 Order Summary
            if (status == "Completed")
              Card(
                color: Colors.green.shade100,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text("Order Completed ✅",
                          style: TextStyle(fontSize: 18)),
                      Text("Date: ${selectedDate.toString().split(" ")[0]}"),
                      Text("Time: $timeSlot"),
                      Text("Total Paid: ₹$total"),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}