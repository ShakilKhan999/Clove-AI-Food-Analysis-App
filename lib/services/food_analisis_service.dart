import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import '../models/food_analysis_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb, compute;
import 'package:image_picker/image_picker.dart';

class FoodAnalysisService {
  static const String baseUrl =
      'https://elario-backend.aisapiens.online/api/food-vision/analyze';

  // Isolate function for image processing
  static Future<Uint8List> _processImageIsolate(Uint8List input) async {
    img.Image? image = img.decodeImage(input);
    if (image == null) throw Exception('Could not decode image');

    // Resize if too large
    if (image.width > 1024 || image.height > 1024) {
      image = img.copyResize(
        image,
        width: image.width > image.height ? 1024 : null,
        height: image.height >= image.width ? 1024 : null,
      );
    }

    // Convert to JPEG with quality setting
    return Uint8List.fromList(img.encodeJpg(image, quality: 85));
  }

  static Future<FoodAnalysisResponse> analyzeFood(
      dynamic imageInput, void Function(String) onStatusUpdate) async {
    try {
      onStatusUpdate('Starting image processing...');

      // Create the multipart request
      var request = http.MultipartRequest('POST', Uri.parse(baseUrl));
      request.headers.addAll({
        'Accept': 'application/json',
        'Content-Type': 'multipart/form-data',
      });

      // Process and add the image based on platform and input type
      await _addImageToRequest(request, imageInput, onStatusUpdate);

      onStatusUpdate('Sending request to server...');
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      onStatusUpdate('Processing response...');
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      var jsonResponse = json.decode(response.body);

      if (response.statusCode == 200 && jsonResponse['success'] == true) {
        return FoodAnalysisResponse.fromJson(jsonResponse);
      } else {
        throw Exception(jsonResponse['error'] ?? 'Failed to analyze image');
      }
    } catch (e, stack) {
      print('Error: $e');
      print('Stack trace: $stack');
      rethrow;
    }
  }

  static Future<void> _addImageToRequest(http.MultipartRequest request,
      dynamic imageInput, void Function(String) onStatusUpdate) async {
    if (imageInput is XFile) {
      // Handle XFile (Web and Mobile)
      final bytes = await imageInput.readAsBytes();

      onStatusUpdate('Processing image...');
      final processedBytes = kIsWeb
          ? await compute(_processImageIsolate, bytes) // Use compute for web
          : await _processImageBytes(bytes); // Direct processing for mobile

      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          processedBytes,
          filename: 'image.jpg',
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    } else if (imageInput is File && !kIsWeb) {
      // Handle File (Mobile only)
      onStatusUpdate('Processing image...');
      final processedImage = await _processImage(imageInput);

      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          processedImage.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      // Clean up the processed image
      if (await processedImage.exists()) {
        await processedImage.delete();
      }
    } else {
      throw Exception(
          'Unsupported image input type: ${imageInput.runtimeType}');
    }
  }

  static Future<Uint8List> _processImageBytes(Uint8List input) async {
    return _processImageIsolate(input);
  }

  static Future<File> _processImage(File input) async {
    final bytes = await input.readAsBytes();
    final processedBytes = await _processImageBytes(bytes);

    // Save to temporary file
    Directory tempDir = await getTemporaryDirectory();
    String tempPath =
        '${tempDir.path}/processed_${DateTime.now().millisecondsSinceEpoch}.jpg';
    File tempFile = File(tempPath);
    await tempFile.writeAsBytes(processedBytes);

    return tempFile;
  }
}