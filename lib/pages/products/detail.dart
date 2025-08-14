import 'package:api_flutter/models/product_models.dart';
import 'package:api_flutter/pages/menu_screen.dart';
import 'package:api_flutter/pages/posts/edit_post.dart';
import 'package:api_flutter/services/order_services.dart';
import 'package:api_flutter/services/post_service.dart';
import 'package:flutter/material.dart';

class ProductDetailScreen extends StatefulWidget {
  final DataProduct product;

  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _qtyController = TextEditingController();
  final OrderServices _orderService = OrderServices();

  // Future<void> _deletePost() async {
  //   final confirmed = await showDialog<bool>(
  //     context: context,
  //     builder: (_) => AlertDialog(
  //       title: const Text("Hapus Post"),
  //       content: Text('Yakin ingin menghapus "${widget.product.name}"?'),
  //       actions: [
  //         TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
  //         ElevatedButton(onPressed: () => Navigator.pop(context, true), style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: Text("Hapus"))
  //       ],
  //     )
  //   );

  //   if(confirmed == true){
  //     setState(() => _isLoading = true);
  //     final success = await PostService.deletePost(widget.product.id!);
  //     if(success && mounted) {
  //       Navigator.pop(context, true);
  //       ScaffoldMessenger.of(context,).showSnackBar(const SnackBar(content: Text("Post berhasil dihapus")));
  //     }
  //     setState(() => _isLoading = false);
  //   }
  // }

  String _formatDate(DateTime date) => "${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name ?? 'Detail Post'),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.delete),
        //     onPressed: _isLoading ? null : _deletePost,
        //   )
        // ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (widget.product.foto != null && widget.product.foto!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                'http://localhost:8000/storage/${widget.product.foto!}',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 100,),

              ),
            ),
          SizedBox(height: 16,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Chip(
                label: Text(widget.product.category?.name ?? 'Tanpa Kategori',),
                backgroundColor: widget.product.category?.id == 1 ? Colors.green.shade100 : Colors.orange.shade100,
              ),
              if(widget.product.createdAt != null)
                Text(
                  _formatDate(widget.product.createdAt!),
                  style: TextStyle(color: Colors.grey.shade600,fontSize: 12),
                )
            ],
          ),
          const SizedBox(height: 16,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.product.name ?? 'Tidak ada nama',
                style: const TextStyle(fontSize: 20, height: 1.6),
              ),
              Text('Rp.'+
                widget.product.price.toString(),
                style: const TextStyle(fontSize: 20, height: 1.6),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.product.desc ?? 'Tidak ada konten',
                style: const TextStyle(fontSize: 16, height: 1.4),
              ),
              Text('Stock : '+
                widget.product.stock.toString(),
                style: const TextStyle(fontSize: 16, height: 1.4),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // FORM PEMESANAN
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Form Pemesanan",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                // Input Qty
                TextFormField(
                  controller: _qtyController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Jumlah",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Jumlah wajib diisi";
                    }
                    if (int.tryParse(value) == null ||
                        int.parse(value) < 1) {
                      return "Jumlah tidak valid";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Tombol Pesan
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                        bool success = await _orderService.createOrder(
                          qty: int.parse(_qtyController.text),
                          price: widget.product.price,
                          idProduct: widget.product.id!,
                        );

                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Pesanan berhasil dibuat'),
                              backgroundColor: Colors.green,
                            ),
                          );

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => MenuScreen()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Pesanan gagal dibuat'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }

                      },
                    // onPressed: () {
                    //   if (_formKey.currentState!.validate()) {
                    //     final orderData = {
                    //       "id_product": widget.product.id,
                    //       "qty": int.parse(_qtyController.text),
                    //     };

                    //     // TODO: kirim ke backend pake service lu
                    //     print(orderData);
                    //     ScaffoldMessenger.of(context).showSnackBar(
                    //       const SnackBar(
                    //           content: Text("Pesanan berhasil dibuat")),
                    //     );
                    //   }
                    // },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Pesan Sekarang",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            )
          ),
          
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.edit),
      //   onPressed: () async {
      //     final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => EditPostScreen(post: widget.post)));
      //     if ( result == true && mounted){
      //       Navigator.pop(context, true);
      //     }
      //   },
      // ),
    );
  }
}