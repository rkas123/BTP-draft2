import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:http/http.dart' as http;

class VoiceAssist extends StatefulWidget {
  static const routeName = '/voice-assist';
  final baseUrl;
  VoiceAssist(this.baseUrl, {Key key}) : super(key: key);

  @override
  _VoiceAssistState createState() => _VoiceAssistState();
}

class _VoiceAssistState extends State<VoiceAssist> {
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  String matchingStatement = '';
  String lastSent = '';
  String similarCommand = '';
  var similarity;
  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  void sendText(String text) async {
    lastSent = text;
    final url = Uri.parse("${widget.baseUrl}/raahi/voice-assistance");
    final res = await http.post(url, body: {
      'text': text,
    });

    final data = json.decode(res.body);
    setState(() {
      similarCommand = data['command'];
      similarity = data['similarity'];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_speechToText.isNotListening &&
        _speechToText.lastRecognizedWords != '' &&
        _speechToText.lastRecognizedWords != lastSent) {
      sendText(_speechToText.lastRecognizedWords);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Speech Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                'Recognized words:',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                // If listening is active show the recognized words
                _speechToText.isListening
                    ? '$_lastWords'
                    // If listening isn't active but could be tell the user
                    // how to start it, otherwise indicate that speech
                    // recognition is not yet ready or not supported on
                    // the target device
                    : _speechEnabled
                        ? 'Tap the microphone to start listening...'
                        : 'Speech not available',
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                'Recognized Commands:',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                'Statement : ${lastSent}',
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                'Similar Command : ${similarCommand}',
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Text('Similarity : ${similarity}'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            // If not yet listening for speech start, otherwise stop
            _speechToText.isNotListening ? _startListening : _stopListening,
        tooltip: 'Listen',
        child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
      ),
    );
  }
}
