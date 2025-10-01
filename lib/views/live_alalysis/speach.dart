import 'dart:html' as html;
import 'dart:js' as js;
class JsSpeechRecognition {
  late js.JsObject _recognition;
  bool _isInitialized = false;

  Function(String)? onResult;
  Function()? onStart;
  Function()? onEnd;
  Function(String)? onError;

  JsSpeechRecognition() {
    _initSpeechRecognition();
  }

  void _initSpeechRecognition() {
    try {
      if (js.context.hasProperty('webkitSpeechRecognition')) {
        _recognition = js.JsObject(js.context['webkitSpeechRecognition']);
      } else if (js.context.hasProperty('SpeechRecognition')) {
        _recognition = js.JsObject(js.context['SpeechRecognition']);
      } else {
        print('Speech recognition not supported');
        return;
      }

      _recognition['continuous'] = false;
      _recognition['interimResults'] = true;
      _recognition['lang'] = 'en-US';

      _recognition['onstart'] = js.allowInterop(() {
        print('Speech recognition started');
        onStart?.call();
      });

      _recognition['onend'] = js.allowInterop(() {
        print('Speech recognition ended');
        onEnd?.call();
      });

      _recognition['onresult'] = js.allowInterop((event) {
        final results = js.JsObject.fromBrowserObject(event)['results'];
        final lastResult = js.JsObject.fromBrowserObject(results[results['length'] - 1]);

        if (lastResult['isFinal'] == true) {
          final transcript = lastResult[0]['transcript'] as String;
          print('Final transcript: $transcript');
          onResult?.call(transcript);
        }
      });

      _recognition['onerror'] = js.allowInterop((event) {
        final error = js.JsObject.fromBrowserObject(event)['error'];
        print('Speech recognition error: $error');
        onError?.call(error.toString());
      });

      _isInitialized = true;
      print('Speech recognition initialized successfully');
    } catch (e) {
      print('Error initializing speech recognition: $e');
      _isInitialized = false;
    }
  }

  void start() {
    if (_isInitialized) {
      try {
        _recognition.callMethod('start');
        print('Speech recognition started successfully');
      } catch (e) {
        print('Error starting speech recognition: $e');
      }
    } else {
      print('Speech recognition not initialized');
    }
  }

  void stop() {
    if (_isInitialized) {
      try {
        _recognition.callMethod('stop');
        print('Speech recognition stopped successfully');
      } catch (e) {
        print('Error stopping speech recognition: $e');
      }
    }
  }
}
