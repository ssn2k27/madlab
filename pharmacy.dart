import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Medicine {
  String name;
  String dosage;
  bool prescription;
  bool expirySoon;
  double price;

  Medicine(this.name, this.dosage, this.prescription, this.expirySoon, this.price);
}

class CartItem {
  Medicine medicine;
  int quantity;

  CartItem(this.medicine, this.quantity);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pharmacy Store',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const MedicinePage(),
    );
  }
}

class MedicinePage extends StatefulWidget {
  const MedicinePage({super.key});

  @override
  State<MedicinePage> createState() => _MedicinePageState();
}

class _MedicinePageState extends State<MedicinePage> {
  final List<Medicine> medicines = [
    Medicine("Paracetamol", "500mg", false, false, 20),
    Medicine("Amoxicillin", "250mg", true, true, 50),
    Medicine("Cough Syrup", "10ml", false, false, 80),
  ];

  final List<CartItem> cart = [];

  void addToCart(Medicine med) {
    setState(() {
      int index = cart.indexWhere((item) => item.medicine == med);
      if (index != -1) {
        if (cart[index].quantity < 5) {
          cart[index].quantity++;
        }
      } else {
        cart.add(CartItem(med, 1));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pharmacy Store"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CartPage(cart: cart),
                ),
              );
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: medicines.length,
        itemBuilder: (context, index) {
          final med = medicines[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(med.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Dosage: ${med.dosage}"),
                  Text("Prescription: ${med.prescription ? "Required" : "No"}"),
                  if (med.expirySoon)
                    const Text("⚠ Expiring Soon!", style: TextStyle(color: Colors.red)),
                ],
              ),
              trailing: ElevatedButton(
                onPressed: () => addToCart(med),
                child: const Text("Add"),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CartPage extends StatefulWidget {
  final List<CartItem> cart;

  const CartPage({super.key, required this.cart});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final double taxRate = 0.1;

  double get totalPrice {
    return widget.cart.fold(
      0,
          (sum, item) => sum + (item.medicine.price * item.quantity),
    );
  }

  @override
  Widget build(BuildContext context) {
    double tax = totalPrice * taxRate;
    double finalTotal = totalPrice + tax;

    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.cart.length,
              itemBuilder: (context, index) {
                final item = widget.cart[index];
                return ListTile(
                  title: Text(item.medicine.name),
                  subtitle: Text("₹${item.medicine.price} x ${item.quantity}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (item.quantity > 1) item.quantity--;
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            if (item.quantity < 5) item.quantity++;
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Text("Total: ₹$totalPrice"),
          Text("Tax (10%): ₹$tax"),
          Text("Final: ₹$finalTotal"),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CheckoutPage(cart: widget.cart),
                ),
              );
            },
            child: const Text("Confirm & Checkout"),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class CheckoutPage extends StatelessWidget {
  final List<CartItem> cart;

  const CheckoutPage({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    double total = cart.fold(
      0,
          (sum, item) => sum + (item.medicine.price * item.quantity),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Invoice",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...cart.map((item) => Text(
                "${item.medicine.name} x ${item.quantity} = ₹${item.medicine.price * item.quantity}")),
            const SizedBox(height: 10),
            Text("Total: ₹$total"),
            const Divider(),
            const Text(
              "Health Disclaimer:\nConsult a doctor before taking medicines. Do not self-medicate.",
              style: TextStyle(color: Colors.red),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Order Placed"),
                      content: const Text(
                          "Your medicines will be delivered soon."),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                          },
                          child: const Text("OK"),
                        )
                      ],
                    ),
                  );
                },
                child: const Text("Place Order"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
