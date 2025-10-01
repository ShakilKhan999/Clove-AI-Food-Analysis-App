import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatbotController extends GetxController {
  final GenerativeModel model = GenerativeModel(
    model: 'gemini-pro',
    apiKey: 'AIzaSyBXZLw-FPP5s8fJ83hEjHqKA_qd5gNPXUo',
  );
  
  final messageController = TextEditingController();
  RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;

  Future<void> sendMessage(String text) async {
    messages.add({
      'text': text,
      'isUser': true,
    });

    try {
      final content = [
        Content.text('As a food and nutrition expert: $text')
      ];
      final response = await model.generateContent(content);
      
      messages.add({
        'text': response.text ?? 'Sorry, I couldn\'t process that.',
        'isUser': false,
      });
    } catch (e) {
      messages.add({
        'text': 'Sorry, there was an error processing your request.',
        'isUser': false,
      });
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}
