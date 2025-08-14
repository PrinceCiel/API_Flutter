// To parse this JSON data, do
//
//     final orderDetailModel = orderDetailModelFromJson(jsonString);

import 'dart:convert';

OrderDetailModel orderDetailModelFromJson(String str) => OrderDetailModel.fromJson(json.decode(str));

String orderDetailModelToJson(OrderDetailModel data) => json.encode(data.toJson());

class OrderDetailModel {
    bool? success;
    List<DataDetailOrder>? data;
    String? message;

    OrderDetailModel({
        this.success,
        this.data,
        this.message,
    });

    factory OrderDetailModel.fromJson(Map<String, dynamic> json) => OrderDetailModel(
        success: json["success"],
        data: json["data"] == null ? [] : List<DataDetailOrder>.from(json["data"]!.map((x) => DataDetailOrder.fromJson(x))),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message,
    };
}

class DataDetailOrder {
    int? id;
    int? idUser;
    String? orderCode;
    int? total;
    DateTime? createdAt;
    DateTime? updatedAt;

    DataDetailOrder({
        this.id,
        this.idUser,
        this.orderCode,
        this.total,
        this.createdAt,
        this.updatedAt,
    });

    factory DataDetailOrder.fromJson(Map<String, dynamic> json) => DataDetailOrder(
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
