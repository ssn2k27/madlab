import 'package:flutter/material.dart';

void main() {
  runApp(const ElectricityApp());
}

class ElectricityApp extends StatelessWidget {
  const ElectricityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Electricity Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String selectedAppliance = "Fan";

  final Map<String, double> appliancePower = {
    "Fan": 75,
    "AC": 1500,
    "Refrigerator": 200,
    "Washing Machine": 500,
  };

  double power = 75;
  double hours = 5;
  double days = 30;
  double costPerUnit = 8;

  double get energyUsed => (power * hours * days) / 1000;
  double get monthlyBill => energyUsed * costPerUnit;
  double get yearlyBill => monthlyBill * 12;

  Color get usageColor {
    if (energyUsed < 50) return Colors.green;
    if (energyUsed < 200) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Electricity Bill Calculator"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🔽 Dropdown
            DropdownButtonFormField<String>(
              value: selectedAppliance,
              decoration: const InputDecoration(
                labelText: "Select Appliance",
                border: OutlineInputBorder(),
              ),
              items: appliancePower.keys.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedAppliance = value!;
                  power = appliancePower[value]!;
                });
              },
            ),

            const SizedBox(height: 20),

            /// ⚡ Power Input
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Power (Watts)",
                border: OutlineInputBorder(),
              ),
              onChanged: (val) {
                setState(() {
                  power = double.tryParse(val) ?? power;
                });
              },
            ),

            const SizedBox(height: 20),

            /// 📅 Days Input
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Number of Days",
                border: OutlineInputBorder(),
              ),
              onChanged: (val) {
                setState(() {
                  days = double.tryParse(val) ?? days;
                });
              },
            ),

            const SizedBox(height: 20),

            /// 💰 Cost Input
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Cost per Unit (₹)",
                border: OutlineInputBorder(),
              ),
              onChanged: (val) {
                setState(() {
                  costPerUnit = double.tryParse(val) ?? costPerUnit;
                });
              },
            ),

            const SizedBox(height: 20),

            /// 🎚 Slider (Usage Hours)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Usage Hours per Day: ${hours.toStringAsFixed(1)}"),
                Slider(
                  min: 0,
                  max: 24,
                  divisions: 24,
                  value: hours,
                  label: hours.toStringAsFixed(1),
                  onChanged: (val) {
                    setState(() {
                      hours = val;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// ⚡ Energy Meter
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text("Energy Meter",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),

                    const SizedBox(height: 10),

                    LinearProgressIndicator(
                      value: (energyUsed / 300).clamp(0, 1),
                      minHeight: 12,
                      color: usageColor,
                      backgroundColor: Colors.grey.shade300,
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "${energyUsed.toStringAsFixed(2)} kWh",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: usageColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// 📊 Results
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    buildResult("Monthly Bill", "₹ ${monthlyBill.toStringAsFixed(2)}"),
                    buildResult("Yearly Projection", "₹ ${yearlyBill.toStringAsFixed(2)}"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildResult(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          Text(value,
              style:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}