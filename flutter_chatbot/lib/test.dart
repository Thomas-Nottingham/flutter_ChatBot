import 'package:flutter/material.dart';
import 'package:flutter_chatbot/feature_box.dart';
import 'package:flutter_chatbot/openai_service.dart';
import 'package:flutter_chatbot/pallete.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  final flutterTts = FlutterTts();

  String lastWords = '';
  
  final OpenAIService openAIService = OpenAIService();


  @override
  void initState() {
    super.initState();
    // Add any initialization code here if needed
    initSpeechToText();
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {
      // Update the state to reflect that the speech recognizer is initialized
    });
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
    //print(lastWords);
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  @override
  void dispose() {
    speechToText.stop();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('General Sand'),
        leading: const Icon(Icons.menu),
      ),
      body: SingleChildScrollView(
        child: Column(
            children: [
                Stack(
                  children: [
                    Center(
                      child: Container(
                        height: 120,
                        width: 120,
                        margin: const EdgeInsets.only(top: 4),
                        decoration: const BoxDecoration(
                          color: Pallete.assistantCircleColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Container(
                      height: 123,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/images/virtualAssistant.png',
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  margin: const EdgeInsets.symmetric(horizontal: 40).copyWith(top:15),
                  decoration: BoxDecoration(border: Border.all(color: Pallete.borderColor),
                  borderRadius:  BorderRadius.circular(20).copyWith(
                    topLeft: Radius.zero,
                  ),
                  ),
                  child: const Padding(
                    padding:  EdgeInsets.symmetric(vertical: 10),
                    child: Text('Good Morning, what task can I do for you?',style: TextStyle(color: Pallete.mainFontColor,fontSize: 22, fontFamily:"Cera Pro"),),
                  ),
                ),
                Container(
                alignment: Alignment.centerLeft, 
                padding: const EdgeInsets.all(10), 
                margin: const EdgeInsets.only(left: 22, top: 5),
                  child: const Text('Here are a few features', style: TextStyle(color: Pallete.mainFontColor,fontSize: 18, fontFamily:"Cera Pro", fontWeight: FontWeight.bold),)),
                
                //features section
                Column(
                  children: [
                    FeatureBox(color: Pallete.firstSuggestionBoxColor, headerText: "ChatGPT", descriptionText: "A smarter way to stay organized and informed with ChatGPT"),
                    FeatureBox(color: Pallete.secondSuggestionBoxColor, headerText: "Dall-E", descriptionText: "Get inspired and stay creative with your personal assistant powered by Dall-E"),
                    FeatureBox(color: Pallete.thirdSuggestionBoxColor, headerText: "Smart Voice Assistant", descriptionText: "Get the best of both worlds with a voice assistant powered by Dall-E and ChatGPT"),
        
        
                  ],
                )
            ],
          ),



      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (await speechToText.hasPermission && speechToText.isNotListening) {
            await startListening();
            
          } else if(speechToText.isListening) {
            final speech = await openAIService.isArtPromptAPI(lastWords);
            await systemSpeak(speech);
            await stopListening();
            
          } else {
            await initSpeechToText();
          }
        },
        backgroundColor: Pallete.mainFontColor,
        child: const Icon(Icons.mic, color: Pallete.whiteColor),
      ),
      );

  }
}