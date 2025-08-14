// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

ProductModel productModelFromJson(String str) => ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
    bool? success;
    List<DataProduct>? data;
    String? message;

    ProductModel({
        this.success,
        this.data,
        this.message,
    });

    factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        success: json["success"],
        data: json["data"] == null ? [] : List<DataProduct>.from(json["data"]!.map((x) => DataProduct.fromJson(x))),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message,
    };
}

class DataProduct {
    int? id;
    String? name;
    String? desc;
    int? price;
    int? stock;
    String? foto;
    int? idCategory;
    DateTime? createdAt;
    DateTime? updatedAt;
    Category? category;

    DataProduct({
        this.id,
        this.name,
        this.desc,
        this.price,
        this.stock,
        this.foto,
        this.idCategory,
        this.createdAt,
        this.updatedAt,
        this.category,
    });

    factory DataProduct.fromJson(Map<String, dynamic> json) => DataProduct(
        id: json["id"],
        name: json["name"],
        desc: json["desc"],
        price: json["price"],
        stock: json["stock"],
        foto: json["foto"],
        idCategory: json["id_category"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        category: json["category"] == null ? null : Category.fromJson(json["category"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "desc": desc,
        "price": price,
        "stock": stock,
        "foto": foto,
        "id_category": idCategory,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "category": category?.toJson(),
    };
}

class Category {
    int? id;
    String? name;
    String? slug;
    String? foto;
    DateTime? createdAt;
    DateTime? updatedAt;

    Category({
        this.id,
        this.name,
        this.slug,
        this.foto,
        this.createdAt,
        this.updatedAt,
    });

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        foto: json["foto"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "foto": foto,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
