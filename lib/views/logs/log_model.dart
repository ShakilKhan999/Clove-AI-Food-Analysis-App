import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/food_analysis_model.dart';
import '../../models/food_model.dart';

class LogModel {
  final DateTime? logTime;
  final String? message;
  final bool? success;
  final FoodData? foodData;

  LogModel({
    this.logTime,
    this.message,
    this.success,
    this.foodData,
  });

  factory LogModel.fromJson(Map<String, dynamic> json) {
    return LogModel(
      logTime: json['logTime'] != null
          ? (json['logTime'] as Timestamp).toDate()
          : null,
      message: json['message'],
      success: json['success'],
      foodData: json['data'] != null
          ? FoodData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'logTime': logTime != null ? Timestamp.fromDate(logTime!) : null,
      'message': message,
      'success': success,
      'foodData': foodData?.toJson(),
    };
  }

}
