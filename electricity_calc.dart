import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ElectricityScreen(),
    );
  }
}

class ElectricityScreen extends StatefulWidget {
  @override
  _ElectricityScreenState createState() => _ElectricityScreenState();
}

class _ElectricityScreenState extends State<ElectricityScreen> {
  String appliance = "Fan";

  double power = 75; // watts
  double hours = 5;
  double days = 30;
  double cost = 6;

  Map<String, double> appliancePower = {
    "Fan": 75,
    "AC": 1500,
    "Refrigerator": 200,
    "Washing Machine": 500
  };

  double get energy => (power * hours * days) / 1000; // kWh
  double get monthlyBill => energy * cost;
  double get yearlyBill => monthlyBill * 12;

  Color get usageColor {
    if (monthlyBill > 800) return Colors.red;
    if (monthlyBill > 300) return Colors.orange;
    return Colors.green;
  }

  double get meterValue {
    return (monthlyBill / 1000).clamp(0, 1); // normalize
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Electricity Calculator ⚡")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔽 Appliance Dropdown
            DropdownButton(
              value: appliance,
              items: appliancePower.keys
                  .map((e) => DropdownMenuItem(
                  value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  appliance = val.toString();
                  power = appliancePower[appliance]!;
                });
              },
            ),

            SizedBox(height: 20),

            // ⚡ Power Slider
            buildSlider("Power (Watts)", power, 0, 2000,
                    (v) => setState(() => power = v)),

            // ⏱ Usage Hours
            buildSlider("Usage Hours/day", hours, 0, 24,
                    (v) => setState(() => hours = v)),

            // 📅 Days
            buildSlider("Days Used", days, 1, 30,
                    (v) => setState(() => days = v)),

            // 💰 Cost
            buildSlider("Cost per Unit (₹)", cost, 1, 15,
                    (v) => setState(() => cost = v)),

            SizedBox(height: 20),

            // ⚡ Energy Meter
            Column(
              children: [
                Text("Energy Meter",
                    style:
                    TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                LinearProgressIndicator(
                  value: meterValue,
                  minHeight: 15,
                  color: usageColor,
                  backgroundColor: Colors.grey[300],
                ),
              ],
            ),

            SizedBox(height: 20),

            // 📊 Results Dashboard
            Card(
              elevation: 5,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    buildResult("Energy Used",
                        "${energy.toStringAsFixed(2)} kWh"),
                    buildResult("Monthly Bill",
                        "₹${monthlyBill.toStringAsFixed(2)}"),
                    buildResult("Yearly Projection",
                        "₹${yearlyBill.toStringAsFixed(2)}"),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // 🎨 Usage Indicator
            Text(
              monthlyBill > 800
                  ? "High Usage ⚠️"
                  : monthlyBill > 300
                  ? "Medium Usage ⚡"
                  : "Low Usage ✅",
              style: TextStyle(
                  fontSize: 18,
                  color: usageColor,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSlider(String title, double value, double min,
      double max, Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$title: ${value.toStringAsFixed(1)}"),
        Slider(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget buildResult(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(value,
              style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}