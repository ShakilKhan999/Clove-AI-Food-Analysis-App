import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_recepi/views/live_alalysis/voice_wave.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

import '../../models/food_analysis_model.dart';
import '../../models/recipe_model.dart';

class VoiceInteraction extends StatefulWidget {
  final Function(String) onVoiceCommand;
  final RecipeResponse? recipeResponse;
  final FoodAnalysisResponse? foodResponse;
  final bool isProcessing;
  final int selectedRecipeIndex;
  final Function(int) onRecipeChange;
  final GenerativeModel model; // Add this line

  const VoiceInteraction({
    Key? key,
    required this.onVoiceCommand,
    this.recipeResponse,
    this.foodResponse,
    this.isProcessing = false,
    required this.selectedRecipeIndex,
    required this.onRecipeChange,
    required this.model, // Add this line
  }) : super(key: key);

  @override
  _VoiceInteractionState createState() => _VoiceInteractionState();
}

class _VoiceInteractionState extends State<VoiceInteraction> {
  bool _isListening = false;
  bool _isSpeaking = false;
  String _currentTranscript = '';
  Timer? _autoStartTimer;
  stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    print('Initializing voice interaction 2nd page');
    _initializeSpeech();
    _initializeTextToSpeech();
    _autoStartConversation();
  }

  void _initializeSpeech() async {
    try {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        print('Speech systems initialized successfully');
        _setupRecognitionHandlers();
      } else {
        print('Speech Recognition not available');
      }
    } catch (e) {
      print('Error initializing speech: $e');
    }
  }

  void _setupRecognitionHandlers() {
    _speech.listen(onResult: (val) {
      print('Step 1: Event received.');

      try {
        _currentTranscript = val.recognizedWords;

        if (val.finalResult) {
          print('Final transcript received: ${val.recognizedWords}');
          _handleVoiceCommand(_currentTranscript);
        }

      } catch (e, stack) {
        print('Error in speech recognition: $e');
        print('Stack trace: $stack');
      }
    });
  }

  void _initializeTextToSpeech() async {
    await _flutterTts.setLanguage("en-US"); // Set language for text-to-speech
    await _flutterTts.setSpeechRate(0.5); // Adjust speech rate as needed
    await _flutterTts.setPitch(1.0); // Adjust pitch as needed
  }

  void _autoStartConversation() {
    if (widget.recipeResponse?.recipes != null &&
        widget.recipeResponse!.recipes.isNotEmpty) {
      _autoStartTimer = Timer(Duration(seconds: 1), () {
        final recipe = widget.recipeResponse!.recipes[widget.selectedRecipeIndex];
        _speakResponse(
            "I see you're looking at ${recipe.name}. "
                "Would you like to know more about this recipe or hear some cooking tips?"
        );
      });
    }
  }

  Future<String> _getGeminiResponse(String userCommand, String context) async {
    print("ai calling?");
    try {
      final prompt = '''
        Context about the recipe and food analysis:
        $context
        
        User's voice command/question:
        $userCommand
        
        Please provide a helpful, concise response about the recipe or nutritional information.
        Focus on directly answering the user's question or responding to their command.
        Keep the response conversational and easy to listen to.
      ''';

      // Use the passed model instance
      final response = await widget.model.generateContent([
        Content.text(prompt),
      ]);

      return response.text ?? "I apologize, but I couldn't generate a response. Could you please try again?";
    } catch (e) {
      print('Error getting Gemini response: $e');
      return "I apologize, but I'm having trouble accessing the recipe information right now. Could you please try again?";
    }
  }

  void _speakResponse(String text) async {
    if (text.isNotEmpty) {
      setState(() => _isSpeaking = true);
      await _flutterTts.speak(text);
      setState(() => _isSpeaking = false);
    }
  }

  Future<void> _handleVoiceCommand(String command) async {
    // Stop listening while processing command
    _speech.stop();
    setState(() {
      _isListening = false;
      _currentTranscript = '';
    });

    try {
      // Get current recipe and food analysis data
      final currentRecipe = widget.recipeResponse?.recipes[widget.selectedRecipeIndex];
      final foodAnalysis = widget.foodResponse;

      // Construct context for Gemini
      String context = '';
      if (currentRecipe != null) {
        context += '''
        Recipe Name: ${currentRecipe.name}
        Ingredients: ${currentRecipe.ingredients.join(', ')}
        Instructions: ${currentRecipe.instructions}
      ''';
      }

      if (foodAnalysis != null) {
        context += '''
        Nutritional Information:
        Calories: ${foodAnalysis.data!.nutrition.calories}
        Protein: ${foodAnalysis.data!.nutrition.protein}
        Carbs: ${foodAnalysis.data!.nutrition.carbohydrates}
        Fat: ${foodAnalysis.data!.nutrition.fat}
      ''';
      }

      // Send to Gemini
      final response = await _getGeminiResponse(command, context);

      // Speak the response
      if (response.isNotEmpty) {
        _speakResponse(response);
      }
    } catch (e) {
      print('Error processing voice command: $e');
      _speakResponse("I'm sorry, I had trouble understanding that. Could you please try again?");
    }

    // Call the original handler for any additional processing
    widget.onVoiceCommand(command);
  }


  void _startListening() async {
    if (_speech.isNotListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        _speech.listen(onResult: (val) => setState(() {
          _currentTranscript = val.recognizedWords;
          if (val.finalResult) {
            _handleVoiceCommand(_currentTranscript);
          }
        }));
        setState(() => _isListening = true);
      } else {
        print('The user has denied the use of speech recognition.');
      }
    } else {
      _speech.stop();
      setState(() => _isListening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: widget.isProcessing ? null : () {
                if (_isListening) {
                  _speech.stop();
                  setState(() {
                    _isListening = false;
                    _currentTranscript = '';
                  });
                } else {
                  _startListening();
                }
              },
              borderRadius: BorderRadius.circular(24.r),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 150),
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getStatusColor(),
                  boxShadow: [
                    BoxShadow(
                      color: _getStatusColor().withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  _getStatusIcon(),
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
            ),
            SizedBox(width: 16.w),
            VoiceWaveVisualizer(
              isActive: _isListening || _isSpeaking,
              color: _getStatusColor(),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor() {
    if (_isListening) return Colors.red.shade400;
    if (_isSpeaking) return Colors.blue.shade400;
    if (widget.isProcessing) return Colors.orange.shade400;
    return Colors.green.shade400;
  }

  IconData _getStatusIcon() {
    if (_isListening) return Icons.mic;
    if (_isSpeaking) return Icons.volume_up;
    if (widget.isProcessing) return Icons.hourglass_empty;
    return Icons.mic_none;
  }

  @override
  void dispose() {
    _autoStartTimer?.cancel();
    _speech.stop();
    _flutterTts.stop(); // Stop text-to-speech if active
    super.dispose();
  }
}