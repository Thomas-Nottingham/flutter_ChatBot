import 'package:animate_do/animate_do.dart';
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
  String? generatedContent;
  String? generatedImage;

  int start = 200;
  int delay = 200;

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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true, // Keeps the AppBar fixed at the top
            floating: false,
            centerTitle: true,
            expandedHeight: 20.0, // Optional: Set an expanded height
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: BounceInDown(
                child: const Text(
                  'General Sand',
                  style: TextStyle(fontSize: 26, color: Colors.white),
                ),
              ),
            ),
            leading: const Icon(Icons.menu),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Column(
                children: [
                  ZoomIn(
                    child: Stack(
                      children: [
                        Center(
                          child: Container(
                            height: 120,
                            width: 120,
                            margin: const EdgeInsets.only(top: 4),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Container(
                          height: 123,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage('assets/images/sandGen3.png'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  FadeInRight(
                    child: Visibility(
                      visible: generatedImage == null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 5,
                        ),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 40,
                        ).copyWith(top: 15),
                        decoration: BoxDecoration(
                          border: Border.all(color: Pallete.borderColor),
                          borderRadius: BorderRadius.circular(
                            20,
                          ).copyWith(topLeft: Radius.zero),
                          boxShadow: [
                            BoxShadow(
                              color: Pallete.exoticYellow.withOpacity(
                                0.2,
                              ), // Glow color
                              blurRadius: 5, // Spread of the glow
                              spreadRadius: 0,
                              offset: Offset(0, 0), // Intensity of the glow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            generatedContent == null
                                ? 'Good Morning, what task can I do for you?'
                                : generatedContent!,
                            style: TextStyle(
                              color: Pallete.exoticYellow,
                              fontSize: generatedContent == null ? 22 : 16,
                              fontFamily: "Cera Pro",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (generatedImage != null)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          generatedImage!, // Replace with a valid image URL
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            print("Error loading image: $error");
                            return const Text(
                              'Failed to load image',
                              style: TextStyle(color: Colors.red),
                            );
                          },
                        ),
                      ),
                    ),

                  SlideInLeft(
                    child: Visibility(
                      visible:
                          generatedContent == null && generatedImage == null,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(left: 22, top: 5),
                        child: const Text(
                          'Here are a few features',
                          style: TextStyle(
                            color: Pallete.whiteColor,
                            fontSize: 18,
                            fontFamily: "Cera Pro",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  //features section
                  Visibility(
                    visible: generatedContent == null && generatedImage == null,
                    child: Column(
                      children: [
                        SlideInLeft(
                          delay: Duration(milliseconds: start),
                          child: const FeatureBox(
                            color: Pallete.chatGptColor,
                            headerText: "ChatGPT",
                            descriptionText:
                                "A smarter way to stay organized and informed with ChatGPT",
                          ),
                        ),
                        SlideInLeft(
                          delay: Duration(milliseconds: start + delay),
                          child: FeatureBox(
                            color: Pallete.dallEColor,
                            headerText: "Dall-E",
                            descriptionText:
                                "Get inspired and stay creative with your personal assistant powered by Dall-E",
                          ),
                        ),
                        SlideInLeft(
                          delay: Duration(milliseconds: start + delay + delay),
                          child: FeatureBox(
                            color: Pallete.voiceAssistantColor,
                            headerText: "Smart Voice Assistant",
                            descriptionText:
                                "Get the best of both worlds with a voice assistant powered by Dall-E and ChatGPT",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ],
      ),
      floatingActionButton: ZoomIn(
        delay: Duration(milliseconds: start + delay + delay),
        child: FloatingActionButton(
          onPressed: () async {
            if (await speechToText.hasPermission &&
                speechToText.isNotListening) {
              await startListening();
            } else if (speechToText.isListening) {
              final speech = await openAIService.isArtPromptAPI(lastWords);

              if (speech.contains('https')) {
                setState(() {
                  generatedImage = speech;
                  generatedContent = null;
                });
              } else {
                setState(() {
                  generatedImage = null;
                  generatedContent = speech;
                });
                await systemSpeak(speech);
              }
              await stopListening();
            } else {
              await initSpeechToText();
            }
          },

          backgroundColor: Pallete.micButtonColor,
          child: Icon(
            color: Pallete.whiteColor,
            speechToText.isListening ? Icons.stop : Icons.mic,
          ),
        ),
      ),
    );
  }
}
