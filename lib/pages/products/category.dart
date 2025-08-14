import 'dart:convert';
import 'package:api_flutter/models/category_models.dart';
import 'package:api_flutter/models/product_models.dart';
import 'package:api_flutter/pages/products/list_products.dart';
import 'package:api_flutter/services/category_services.dart';
import 'package:api_flutter/services/product_service.dart';
import 'package:api_flutter/pages/posts/create_post.dart';
import 'package:api_flutter/pages/posts/detail_post.dart';
import 'package:flutter/material.dart';
// import 'package:api_flutter/pages/posts/detail_posts_screen.dart';
// import 'package:api_flutter/pages/posts/create_post_screen.dart';

class ListCategoryScreen extends StatefulWidget {
  const ListCategoryScreen({super.key});

  @override
  State<ListCategoryScreen> createState() => _ListCategoryScreenState();
}

class _ListCategoryScreenState extends State<ListCategoryScreen> {
  late Future<CategoryModel> _futureCategories;

  @override
  void initState() {
    super.initState();
    _futureCategories = CategoryServices.listCategories();
  }

  void _refreshPosts() {
    setState(() {
      _futureCategories = CategoryServices.listCategories();
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
        title: const Text('My Products'),
      ),
      body: FutureBuilder<CategoryModel>(
        future: _futureCategories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final categories = snapshot.data?.data ?? [];
          if (categories.isEmpty) {
            return const Center(child: Text('No categories found'));
          }
          return Padding(
            padding: const EdgeInsets.all(10),
            child: GridView.builder(
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 kolom
                crossAxisSpacing: 5,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                final category = categories[index];
                return GestureDetector(
                    onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ListProductScreen(idCategory: category.id!,)),  
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey[100],
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 6)
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Background image
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: category.foto != null && category.foto!.isNotEmpty
                        ? Image.network(
                            'http://127.0.0.1:8000/storage/${category.foto!}',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.broken_image),
                          )
                        : const Icon(Icons.article),
                          ),
                        ),
                        // Overlay
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ),
                        // Price & Name
                        Positioned(
                          bottom: 10,
                          left: 10,
                          right: 10,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(category.name!,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
