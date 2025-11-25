class SubscriptionDetails {
  final int id;
  final String code;
  final String title;
  final int amount;
  final String createdAt;
  final String updatedAt;

  SubscriptionDetails({
    required this.id,
    required this.code,
    required this.title,
    required this.amount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubscriptionDetails.fromJson(Map<String, dynamic> json) {
    return SubscriptionDetails(
      id: json['id'] as int,
      code: json['code'] as String,
      title: json['title'] as String,
      amount: json['amount'] as int,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'title': title,
      'amount': amount,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class Subscription {
  final int id;
  final int userId;
  final String userIdString;
  final String effectiveTime;
  final String expiryTime;
  final String updateTime;
  final String isOTC;
  final String productId;
  final String serviceId;
  final String spId;
  final String statusCode;
  final String? chargeMode;
  final String? chargeNumber;
  final String? referenceId;
  final SubscriptionDetails details;
  final String createdAt;
  final String updatedAt;

  Subscription({
    required this.id,
    required this.userId,
    required this.userIdString,
    required this.effectiveTime,
    required this.expiryTime,
    required this.updateTime,
    required this.isOTC,
    required this.productId,
    required this.serviceId,
    required this.spId,
    required this.statusCode,
    this.chargeMode,
    this.chargeNumber,
    this.referenceId,
    required this.details,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      userIdString: json['userId'] as String,
      effectiveTime: json['effectiveTime'] as String,
      expiryTime: json['expiryTime'] as String,
      updateTime: json['updateTime'] as String,
      isOTC: json['isOTC'] as String,
      productId: json['productId'] as String,
      serviceId: json['serviceId'] as String,
      spId: json['spId'] as String,
      statusCode: json['statusCode'] as String,
      chargeMode: json['chargeMode'] as String?,
      chargeNumber: json['chargeNumber'] as String?,
      referenceId: json['referenceId'] as String?,
      details: SubscriptionDetails.fromJson(json['details'] as Map<String, dynamic>),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'userId': userIdString,
      'effectiveTime': effectiveTime,
      'expiryTime': expiryTime,
      'updateTime': updateTime,
      'isOTC': isOTC,
      'productId': productId,
      'serviceId': serviceId,
      'spId': spId,
      'statusCode': statusCode,
      'chargeMode': chargeMode,
      'chargeNumber': chargeNumber,
      'referenceId': referenceId,
      'details': details.toJson(),
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
