import 'package:api_flutter/models/order_detail_models.dart';
import 'package:api_flutter/services/order_services.dart';
import 'package:flutter/material.dart';

class OrderDetailPage extends StatefulWidget {
  final String orderCode;

  const OrderDetailPage({super.key, required this.orderCode});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  late Future<DataDetailOrder> _orderFuture;

  @override
  void initState() {
    super.initState();
    _orderFuture = OrderServices.showPost(widget.orderCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Detail"),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<DataDetailOrder>(
        future: _orderFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No order found"));
          }

          final order = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Order Code: ${order.orderCode ?? '-'}",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text("Total: Rp ${order.total}"),
                    Text("Quantity: ${order.qty}"),
                    Text("Price per item: Rp ${order.price}"),
                    const Divider(height: 24),
                    Text("Product Name: ${order.productName ?? '-'}",
                        style: const TextStyle(fontSize: 16)),
                    Text("Status: ${order.status ?? '-'}"),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.check_circle),
                      label: const Text("Mark as Completed"),
                      onPressed: () {
                        // action misal update status
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
