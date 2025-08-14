// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

CategoryModel categoryModelFromJson(String str) => CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
    bool? success;
    List<DataCategory>? data;
    String? message;

    CategoryModel({
        this.success,
        this.data,
        this.message,
    });

    factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        success: json["success"],
        data: json["data"] == null ? [] : List<DataCategory>.from(json["data"]!.map((x) => DataCategory.fromJson(x))),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message,
    };
}

class DataCategory {
    int? id;
    String? name;
    String? slug;
    String? foto;
    DateTime? createdAt;
    DateTime? updatedAt;

    DataCategory({
        this.id,
        this.name,
        this.slug,
        this.foto,
        this.createdAt,
        this.updatedAt,
    });

    factory DataCategory.fromJson(Map<String, dynamic> json) => DataCategory(
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
