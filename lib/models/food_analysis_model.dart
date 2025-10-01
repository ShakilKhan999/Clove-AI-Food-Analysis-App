

import 'food_model.dart';

class FoodAnalysisResponse {
  final bool success;
  final String message;
  final FoodData? data;
  final String? error;

  FoodAnalysisResponse({
    required this.success,
    required this.message,
    this.data,
    this.error,
  });

  factory FoodAnalysisResponse.fromJson(Map<String, dynamic> json) {
    return FoodAnalysisResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? json['error'] ?? '',
      data: json['data'] != null ? FoodData.fromJson(json['data']) : null,
      error: json['error'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
      'error': error,
    };
  }
}
