// ignore_for_file: unnecessary_string_interpolations

import 'dart:convert';
import 'package:api_flutter/models/order_models.dart';
import 'package:api_flutter/pages/orders/detail.dart';
import 'package:api_flutter/pages/posts/create_post.dart';
import 'package:api_flutter/pages/posts/detail_post.dart';
import 'package:api_flutter/services/order_services.dart';
import 'package:flutter/material.dart';
import 'package:api_flutter/models/post_models.dart';
import 'package:api_flutter/services/post_service.dart';
// import 'package:api_flutter/pages/posts/detail_posts_screen.dart';
// import 'package:api_flutter/pages/posts/create_post_screen.dart';

class ListOrdersScreen extends StatefulWidget {
  const ListOrdersScreen({super.key});

  @override
  State<ListOrdersScreen> createState() => _ListOrdersScreenState();
}

class _ListOrdersScreenState extends State<ListOrdersScreen> {
  late Future<OrderModel> _futureOrders;

  @override
  void initState() {
    super.initState();
    _futureOrders = OrderServices.listOrders();
  }

  void _refreshPosts() {
    setState(() {
      _futureOrders = OrderServices.listOrders();
    });
  }

  String _formatDate(dynamic date) {
    if (date == null) return '';

    if (date is DateTime) {
      return '${date.day}/${date.month}/${date.year}';
    }

    if (date is String) {
      final d = DateTime.tryParse(date);
      if (d != null) {
        return '${d.day}/${d.month}/${d.year}';
      }
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Posts'),
        actions: [
          IconButton(onPressed: _refreshPosts, icon: const Icon(Icons.refresh)),
          IconButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreatePostScreen()),
              );
              if (result == true) _refreshPosts();
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder<OrderModel>(
        future: _futureOrders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final orders = snapshot.data?.data ?? [];
          if (orders.isEmpty) {
            return const Center(child: Text('No orders found'));
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderDetailPage(orderCode: order.orderCode!),
                      ),
                    );
                    if (result == true) _refreshPosts();
                  },
                  leading: const Icon(Icons.article),
                  title: Text(order.orderCode ?? 'No Title'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (order.total != null && order.total!.toString().isNotEmpty)
                        Text('Total : Rp.'+
                          order.total.toString(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      Text(
                        '${_formatDate(order.createdAt)}',
                        style: TextStyle(
                          color:Colors.orange,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  trailing: Text('#${order.id}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}