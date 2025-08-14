// To parse this JSON data, do
//
//     final orderModel = orderModelFromJson(jsonString);

import 'dart:convert';

OrderModel orderModelFromJson(String str) => OrderModel.fromJson(json.decode(str));

String orderModelToJson(OrderModel data) => json.encode(data.toJson());

class OrderModel {
    bool? success;
    List<DataOrder>? data;
    String? message;

    OrderModel({
        this.success,
        this.data,
        this.message,
    });

    factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        success: json["success"],
        data: json["data"] == null ? [] : List<DataOrder>.from(json["data"]!.map((x) => DataOrder.fromJson(x))),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message,
    };
}

class DataOrder {
    int? id;
    int? idUser;
    String? orderCode;
    int? total;
    DateTime? createdAt;
    DateTime? updatedAt;

    DataOrder({
        this.id,
        this.idUser,
        this.orderCode,
        this.total,
        this.createdAt,
        this.updatedAt,
    });

    factory DataOrder.fromJson(Map<String, dynamic> json) => DataOrder(
        id: json["id"],
        idUser: json["id_user"],
        orderCode: json["order_code"],
        total: json["total"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "id_user": idUser,
        "order_code": orderCode,
        "total": total,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
