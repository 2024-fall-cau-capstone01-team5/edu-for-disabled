import 'package:flutter/material.dart';
import '../StepData.dart';
import '../tts.dart';

abstract class Scenario_Manager extends ChangeNotifier {
  int flag = 0;
  int flag2 = 0;
  int flag3 = 0;
  int flag4 = 0;
  int flag5 = 0;

  int index = 0;
  List<StepData> stepDatas = [];
  final TTS tts = TTS();

  String get title;
  List<Widget> get leftScreen;
  List<Widget> get rightScreen;
  String get backGroundMusic;


  //abstract으로 정의, 자식 Provider에서 구현하게 됨

  void updateIndex() {
    index++;
    notifyListeners();
    print("index updated!!!! INDEX: $index");
  }

  void addStepInfo(String question, String response) {
    stepDatas.add(StepData(
      title: title,
      scene_id: index,
      question: question,
      response: response,
    ));
  }

  Future<void> playTTS(String text, String name) async {
    await tts.TextToSpeech(text, name);
  }

  void increment_flag(){
    flag = 1;
    print("flagGGGGGG===================================GGGGGGGGGGG: $flag");
    notifyListeners();
  }

  void decrement_flag(){
    flag = 0;
    print("flagGGGGGG===================================GGGGGGGGGGG: $flag");
    notifyListeners();
  }

  void increment_flag2(){
    flag2 = 1;
    print("flagGGGGGG===================================GGGGGGGGGGG: $flag");
    notifyListeners();
  }

  void decrement_flag2(){
    flag2 = 0;
    print("flagGGGGGG===================================GGGGGGGGGGG: $flag");
    notifyListeners();
  }

  void increment_flag3(){
    flag3 = 1;
    print("flagGGGGGG===================================GGGGGGGGGGG: $flag");
    notifyListeners();
  }

  void decrement_flag3(){
    flag3 = 0;
    print("flagGGGGGG===================================GGGGGGGGGGG: $flag");
    notifyListeners();
  }

  void increment_flag4(){
    flag4 = 1;
    print("flagGGGGGG===================================GGGGGGGGGGG: $flag");
    notifyListeners();
  }

  void decrement_flag4(){
    flag4 = 0;
    print("flagGGGGGG===================================GGGGGGGGGGG: $flag");
    notifyListeners();
  }


  void increment_flag5(){
    flag5 = 1;
    print("flagGGGGGG===================================GGGGGGGGGGG: $flag");
    notifyListeners();
  }

  void decrement_flag5(){
    flag5 = 0;
    print("flagGGGGGG===================================GGGGGGGGGGG: $flag");
    notifyListeners();
  }



}