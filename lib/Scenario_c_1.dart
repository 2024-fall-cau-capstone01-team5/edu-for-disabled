import 'package:flutter/material.dart';
import 'package:flutterpractice/providers/Scenario_Manager.dart';
import 'providers/Scenario_c_provider.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'tts.dart'; // TTS 클래스를 정의한 파일을 import하세요.

final AudioPlayer _audioPlayer = AudioPlayer();


class c_1_enterTheStore_left extends StatefulWidget {
  const c_1_enterTheStore_left({super.key});

  @override
  State<c_1_enterTheStore_left> createState() => _c_1_enterTheStore_leftState();
}

class _c_1_enterTheStore_leftState extends State<c_1_enterTheStore_left> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20), // Container의 borderRadius와 동일하게 설정
      child: Image(
        image: AssetImage("assets/c_outside.PNG"),
        fit: BoxFit.cover, // 이미지가 Container에 꽉 차도록 설정
      ),
    );
  }
}

class c_1_enterTheStore_right extends StatefulWidget {
  const c_1_enterTheStore_right({super.key});

  @override
  State<c_1_enterTheStore_right> createState() => _c_1_enterTheStore_rightState();
}

class _c_1_enterTheStore_rightState extends State<c_1_enterTheStore_right> {
  String door_image = "assets/door_closed.png";
  
  final TTS tts = TTS();

  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await tts.TextToSpeech("편의점에 도착했습니다. 저기 편의점 출입구가 보이네요. 왼쪽 화면에 나와있는 문을 터치해서 편의점에 들어가보세요.",
        "ko-KR-Wavenet-D");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(

        onPressed: () async {

          await _audioPlayer.play(AssetSource("effect_door.mp3"));

          setState(() {
            door_image = "assets/door_open.png";
            print("door_image: $door_image");
          });
          await Future.delayed(Duration(seconds: 1));
          setState(() {
            door_image = "";
            print("door_image: $door_image");
          });
          Provider.of<Scenario_Manager>(context, listen: false).updateIndex();
        },
        child: Center(
          child: door_image != ""
              ? Image(
            image: AssetImage(door_image),
          )
              : SizedBox.shrink(),
        ),
      ),
    );
  }
}
