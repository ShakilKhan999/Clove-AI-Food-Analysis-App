import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

import '../../models/food_analysis_model.dart';
import '../../models/recipe_model.dart';
import 'package:http/http.dart' as http;

class LiveFoodAnalysisScreen extends StatefulWidget {
  const LiveFoodAnalysisScreen({super.key});

  @override
  _LiveFoodAnalysisScreenState createState() => _LiveFoodAnalysisScreenState();
}

class _LiveFoodAnalysisScreenState extends State<LiveFoodAnalysisScreen> {
  CameraController? _cameraController;
  bool _isCameraReady = false;
  late GenerativeModel _geminiModel;
  late ChatSession _chatSession;
  Timer? _analysisTimer;
  bool _isAnalyzing = false;
  FoodAnalysisResponse? _currentAnalysis;
  bool _showRecipes = false;
  List<Recipe>? _recipes;
  File? _currentImage;

  // Voice interaction
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  final FlutterTts _textToSpeech = FlutterTts();
  bool _isListening = false;
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _initializeGemini();
    _setupVoiceInteraction();
    _checkPermissions();
    _listAvailableModels();
  }

  void _checkPermissions() async {
    final cameraStatus = await Permission.camera.request();
    final microphoneStatus = await Permission.microphone.request();

    if (cameraStatus.isGranted && microphoneStatus.isGranted) {
      _initializeCamera();
    } else {
      _showPermissionDeniedDialog();
    }
  }

  Future<void> _listAvailableModels() async {
    final apiKey = 'AIzaSyBqAyU9gAbtS_pyUmM4KbK6iBexFcmr_EM';
    final url =
        'https://generativelanguage.googleapis.com/v1beta/models?key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print('Available models:');
        print(response.body);

        final models = json.decode(response.body);
        if (models['models'] != null) {
          for (var model in models['models']) {
            print('Model name: ${model['name']}');
            print('Display name: ${model['displayName']}');
            print(
                'Supported generation methods: ${model['supportedGenerationMethods']}');
            print('---');
          }
        }
      } else {
        print('Failed to fetch models: ${response.statusCode}');
        print('Error: ${response.body}');
      }
    } catch (e) {
      print('Error listing models: $e');
    }
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    _cameraController = CameraController(
      cameras[0],
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    try {
      await _cameraController!.initialize();
      setState(() => _isCameraReady = true);

      _analysisTimer = Timer.periodic(const Duration(seconds: 2), (_) {
        if (!_isAnalyzing) _analyzeCurrentFrame();
      });
    } catch (e) {
      print('Camera initialization error: $e');
    }
  }

  Future<void> _analyzeCurrentFrame() async {
    if (!_isCameraReady || _isAnalyzing) return;

    setState(() => _isAnalyzing = true);

    try {
      final image = await _cameraController!.takePicture();
      _currentImage = File(image.path);
      final bytes = await _currentImage!.readAsBytes();

      const analysisPrompt = '''
      I am a user requesting help. Please:
      1. Identify what food is shown in this image. Be specific.
      2. Provide estimated nutritional information (calories, protein, carbs, fat)
      3. Suggest 3 recipes that can be made with this food item.
      
      Format the response as JSON:
      {
        "success": true,
        "message": "Analysis complete",
        "data": {
          "foodName": "name of the dish",
          "description": "brief description",
          "nutrition": {
            "calories": "estimated calories",
            "carbohydrates": "carbs in grams",
            "protein": "protein in grams",
            "fat": "fat in grams"
          },
          "recommendations": ["recipe 1", "recipe 2", "recipe 3"]
        }
      }''';

      final response = await _geminiModel.generateContent([
        Content.multi([
          TextPart(analysisPrompt),
          DataPart('image/jpeg', bytes),
        ])
      ]);

      if (response.text != null) {
        final cleanJson = response.text!
            .replaceAll('```json', '')
            .replaceAll('```', '')
            .trim();

        final analysisResponse =
            FoodAnalysisResponse.fromJson(json.decode(cleanJson));

        if (analysisResponse.success &&
            _currentAnalysis?.data?.foodName !=
                analysisResponse.data?.foodName) {
          setState(() => _currentAnalysis = analysisResponse);
          _speakFoodAnalysis(analysisResponse);
          await _generateRecipeSuggestions(analysisResponse.data!.foodName);
        }
      }
    } catch (e) {
      print('Analysis error: $e');
    }

    setState(() => _isAnalyzing = false);
  }

  Future<void> _generateRecipeSuggestions(String foodName) async {
    final prompt = '''Suggest 3 recipes for ${foodName} in JSON:
    {
      "recipes": [
        {
          "name": "Recipe Name",
          "description": "Brief description",
          "ingredients": ["ingredient 1", "ingredient 2"],
          "instructions": ["step 1", "step 2"],
          "healthBenefits": "Health benefits"
        }
      ]
    }''';

    try {
      final response =
          await _geminiModel.generateContent([Content.text(prompt)]);
      if (response.text != null) {
        final cleanJson = response.text!
            .replaceAll('```json', '')
            .replaceAll('```', '')
            .trim();

        final recipesData = json.decode(cleanJson);
        setState(() {
          _recipes = (recipesData['recipes'] as List)
              .map((r) => Recipe.fromJson(r))
              .toList();
        });
      }
    } catch (e) {
      print('Recipe generation error: $e');
    }
  }

  void _initializeGemini() {
    _geminiModel = GenerativeModel(
      model: 'gemini-2.5-flash-preview-04-17',
      apiKey: 'AIzaSyBqAyU9gAbtS_pyUmM4KbK6iBexFcmr_EM',
    );

    const initialPrompt =
        '''You are a professional chef and food expert. Your role is to:
    1. Analyze food shown in the camera in real-time
    2. Provide detailed information about the food
    3. Suggest recipes and cooking tips
    4. Answer any food-related questions
    
    Keep responses engaging and informative but brief.''';

    _chatSession =
        _geminiModel.startChat(history: [Content.text(initialPrompt)]);
    _speak("Hello! I'm ready to analyze any food you show me!");
  }

  // Voice interaction methods
  Future<void> _setupVoiceInteraction() async {
    await _speechToText.initialize(
      onStatus: (status) {
        if (status == 'done') setState(() => _isListening = false);
      },
      onError: (error) => print('Speech Error: $error'),
    );

    await _textToSpeech.setLanguage("en-US");
    await _textToSpeech.setSpeechRate(0.5);
  }

  Future<void> _speak(String text) async {
    setState(() => _isSpeaking = true);
    await _textToSpeech.speak(text);
    setState(() => _isSpeaking = false);
  }

  Future<void> _startListening() async {
    if (!_isListening) {
      final available = await _speechToText.initialize();
      if (available) {
        setState(() => _isListening = true);
        await _speechToText.listen(
          onResult: (result) {
            if (result.finalResult) {
              _handleUserVoiceInput(result.recognizedWords);
            }
          },
        );
      }
    }
  }

  void _stopListening() {
    _speechToText.stop();
    setState(() => _isListening = false);
  }

  Future<void> _handleUserVoiceInput(String input) async {
    if (input.isEmpty) return;

    try {
      final foodContext =
          _currentAnalysis?.data?.foodName ?? "no food detected";
      final prompt = '''User asked: "$input"
      Currently analyzing: $foodContext
      
      If they ask about recipes, tell them about available recipes.
      If they ask about nutrition, share the nutritional info.
      Keep responses brief and conversational.''';

      final response = await _chatSession.sendMessage(Content.text(prompt));
      if (response.text != null) {
        await _speak(response.text!);
      }
    } catch (e) {
      await _speak("Sorry, I didn't catch that. Could you try again?");
    }
  }

  Future<void> _speakFoodAnalysis(FoodAnalysisResponse analysis) async {
    final foodInfo = '''I see ${analysis.data!.foodName}! 
    It has ${analysis.data!.nutrition.calories} calories and ${analysis.data!.nutrition.protein}g of protein. 
    Here's a quick tip: ${analysis.data!.recommendations.first}''';

    await _speak(foodInfo);
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Permissions Required'),
        content: const Text(
            'Camera and microphone permissions are required for food analysis and voice commands. '
            'Please enable them in your device settings.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _checkPermissions();
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview
          if (_isCameraReady)
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: CameraPreview(_cameraController!),
            ),

          // Analysis Indicator
          if (_isAnalyzing)
            Positioned(
              top: MediaQuery.of(context).padding.top + 20.h,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      const Text(
                        'Analyzing Food...',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Food Analysis Results
          if (_currentAnalysis?.data != null)
            Positioned(
              top: MediaQuery.of(context).padding.top + 80.h,
              left: 20.w,
              right: 20.w,
              child: Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentAnalysis!.data!.foodName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _buildNutritionInfo(),
                  ],
                ),
              ),
            ),

          // Recipe Display
          if (_showRecipes && _recipes != null) _buildRecipeOverlay(),

          // Voice Interaction Button
          Positioned(
            bottom: 40.h,
            right: 20.w,
            child: GestureDetector(
              onTapDown: (_) => _startListening(),
              onTapUp: (_) => _stopListening(),
              onTapCancel: () => _stopListening(),
              child: Container(
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isListening ? Colors.red : Colors.blue,
                ),
                child: Icon(
                  _isListening ? Icons.mic : Icons.mic_none,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Recipe Toggle Button
          Positioned(
            bottom: 40.h,
            left: 20.w,
            child: FloatingActionButton(
              backgroundColor: Colors.green,
              onPressed: () => setState(() => _showRecipes = !_showRecipes),
              child: const Icon(Icons.menu_book),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionInfo() {
    final nutrition = _currentAnalysis!.data!.nutrition;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with animation
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.black87, Colors.black54],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                const Icon(Icons.restaurant_menu, color: Colors.white70),
                SizedBox(width: 8.w),
                Text(
                  'NUTRITION FACTS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
                const Spacer(),
                Text(
                  'per serving',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 12.sp,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // Nutrition Cards Grid
          Container(
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: EdgeInsets.all(4.r),
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16.h,
                    crossAxisSpacing: 16.w,
                    childAspectRatio: 1.75,
                    children: [
                      _buildNutritionCard(
                        icon: Icons.local_fire_department,
                        label: 'Calories',
                        value: nutrition.calories,
                        color: Colors.orange,
                        gradient: [
                          Colors.orange.shade900,
                          Colors.orange.shade800
                        ],
                      ),
                      _buildNutritionCard(
                        icon: Icons.grain,
                        label: 'Carbs',
                        value: '${nutrition.carbohydrates}g',
                        color: Colors.blue,
                        gradient: [Colors.blue.shade900, Colors.blue.shade800],
                      ),
                      _buildNutritionCard(
                        icon: Icons.fitness_center,
                        label: 'Protein',
                        value: '${nutrition.protein}g',
                        color: Colors.green,
                        gradient: [
                          Colors.green.shade900,
                          Colors.green.shade800
                        ],
                      ),
                      _buildNutritionCard(
                        icon: Icons.opacity,
                        label: 'Fat',
                        value: '${nutrition.fat}g',
                        color: Colors.red,
                        gradient: [Colors.red.shade900, Colors.red.shade800],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required List<Color> gradient,
  }) {
    // Improved value formatting
    final formattedValue = value
        .toLowerCase()
        .replaceAll(
            RegExp(r'approximately|about|around|roughly|estimated|nearly'), '')
        .trim();

    // Handle numeric values with units
    final RegExp numericPattern = RegExp(r'(\d+\.?\d*)\s*(kcal|cal|g|mg|%)?');
    final match = numericPattern.firstMatch(formattedValue);
    final displayValue = match != null
        ? '${match.group(1)}${match.group(2) ?? ''}'
        : formattedValue;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Icon
          Positioned(
            right: -10,
            bottom: -10,
            child: Icon(
              icon,
              size: 80.r,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.all(12.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(icon, color: Colors.white, size: 20.r),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          displayValue,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeOverlay() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Stack(
          children: [
            // Blurred Background
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black87.withOpacity(0.9),
                      Colors.black.withOpacity(0.95),
                    ],
                  ),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
              ),
            ),

            // Content
            Column(
              children: [
                // Handle Bar
                Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 12.h),
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),

                // Header
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recipe Suggestions',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close, color: Colors.white),
                        ),
                        onPressed: () => setState(() => _showRecipes = false),
                      ),
                    ],
                  ),
                ),

                // Recipe List
                Expanded(
                  child: ListView.builder(
                    itemCount: _recipes!.length,
                    padding: EdgeInsets.all(20.r),
                    itemBuilder: (context, index) {
                      final recipe = _recipes![index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 16.h),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.1),
                              Colors.white.withOpacity(0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            dividerColor: Colors.transparent,
                            colorScheme: const ColorScheme.dark(),
                          ),
                          child: ExpansionTile(
                            tilePadding: EdgeInsets.all(16.r),
                            childrenPadding: EdgeInsets.all(16.r),
                            title: Text(
                              recipe.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              recipe.description,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14.sp,
                              ),
                            ),
                            children: [
                              // Recipe Details
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildRecipeSection(
                                    'Ingredients',
                                    recipe.ingredients,
                                    Icons.shopping_basket,
                                  ),
                                  SizedBox(height: 16.h),
                                  _buildRecipeSection(
                                    'Instructions',
                                    recipe.instructions,
                                    Icons.format_list_numbered,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeSection(String title, List<String> items, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white70, size: 20.r),
            SizedBox(width: 8.w),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        ...items
            .map((item) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 6.h),
                        width: 4.w,
                        height: 4.h,
                        decoration: const BoxDecoration(
                          color: Colors.white70,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          item,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14.sp,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ],
    );
  }

  Widget _nutritionItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }

  Future<void> _handleVoiceCommand(String command) async {
    if (command.toLowerCase().contains('recipes')) {
      setState(() => _showRecipes = true);
      await _speak(
          "Here are some recipe suggestions for ${_currentAnalysis?.data?.foodName}");
    } else if (command.toLowerCase().contains('hide recipes')) {
      setState(() => _showRecipes = false);
      await _speak("Hiding recipes");
    } else if (command.toLowerCase().contains('nutrition')) {
      final nutrition = _currentAnalysis?.data?.nutrition;
      if (nutrition != null) {
        await _speak("This food contains ${nutrition.calories} calories, "
            "${nutrition.protein}g protein, "
            "${nutrition.carbohydrates}g carbs, and "
            "${nutrition.fat}g fat");
      }
    } else {
      await _handleUserVoiceInput(command);
    }
  }

  Future<void> _startContinuousListening() async {
    if (!_isListening) {
      final available = await _speechToText.initialize();
      if (available) {
        setState(() => _isListening = true);
        await _speechToText.listen(
          onResult: (result) {
            if (result.finalResult) {
              _handleVoiceCommand(result.recognizedWords);
            }
          },
          listenFor: const Duration(seconds: 30),
          pauseFor: const Duration(seconds: 3),
        );
      }
    }
  }

  Future<void> _handleAnalysisError(String error) async {
    print('Analysis error: $error');
    await _speak("Sorry, I had trouble analyzing that food. Let's try again!");
    setState(() => _isAnalyzing = false);
  }

  Future<void> _refreshAnalysis() async {
    if (!_isAnalyzing) {
      await _analyzeCurrentFrame();
    }
  }

  void _toggleRecipes() {
    setState(() => _showRecipes = !_showRecipes);
    _speak(_showRecipes
        ? "Showing recipes for ${_currentAnalysis?.data?.foodName}"
        : "Hiding recipes");
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _analysisTimer?.cancel();
    _speechToText.cancel();
    _textToSpeech.stop();
    super.dispose();
  }
}
