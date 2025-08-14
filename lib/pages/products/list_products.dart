import 'dart:convert';
import 'package:api_flutter/models/category_models.dart';
import 'package:api_flutter/models/product_models.dart';
import 'package:api_flutter/pages/products/detail.dart';
import 'package:api_flutter/services/product_service.dart';
import 'package:api_flutter/pages/posts/create_post.dart';
import 'package:api_flutter/pages/posts/detail_post.dart';
import 'package:flutter/material.dart';
// import 'package:api_flutter/pages/posts/detail_posts_screen.dart';
// import 'package:api_flutter/pages/posts/create_post_screen.dart';

class ListProductScreen extends StatefulWidget {
  final int idCategory;
  const ListProductScreen({Key? key, required this.idCategory}) : super(key: key);

  @override
  State<ListProductScreen> createState() => _ListProductScreenState();
}

class _ListProductScreenState extends State<ListProductScreen> {
  late Future<ProductModel> _futureProducts;

  @override
  void initState() {
    super.initState();
    _futureProducts = ProductService.listProductsByCategory(widget.idCategory);;
  }

  void _refreshPosts() {
    setState(() {
      _futureProducts = ProductService.listProductsByCategory(widget.idCategory);;
    });
  }

  // String _formatDate(dynamic date) {
  //   if (date == null) return '';

  //   if (date is DateTime) {
  //     return '${date.day}/${date.month}/${date.year}';
  //   }

  //   if (date is String) {
  //     final d = DateTime.tryParse(date);
  //     if (d != null) {
  //       return '${d.day}/${d.month}/${d.year}';
  //     }
  //   }

  //   return '';
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Products'),
        actions: [
          IconButton(onPressed: _refreshPosts, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: FutureBuilder<ProductModel>(
        future: _futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final products = snapshot.data?.data ?? [];
          if (products.isEmpty) {
            return const Center(child: Text('No products found'));
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailScreen(product: product),
                      ),
                    );
                    if (result == true) _refreshPosts();
                  },
                  leading: product.foto != null && product.foto!.isNotEmpty
                      ? Image.network(
                          'http://127.0.0.1:8000/storage/${product.foto!}',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.broken_image),
                        )
                      : const Icon(Icons.article),
                  title: Text(product.name ?? 'No Title'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (product.desc != null && product.desc!.isNotEmpty)
                        Text(
                          product.desc!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      Text(product.category?.name ?? 'Tanpa Kategori',
                        style: TextStyle(
                          color: product.idCategory == 1
                              ? Colors.green
                              : Colors.orange,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  trailing: Text('Rp.${product.price}', style: TextStyle(fontSize: 15),),
                ),
              );
            },
          );
        },
      ),
    );
  }
}