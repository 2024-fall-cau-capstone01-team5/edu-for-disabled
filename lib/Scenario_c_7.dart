import 'package:flutter/material.dart';
import 'package:flutterpractice/providers/Scenario_Manager.dart';
import 'providers/Scenario_c_provider.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'tts.dart'; // TTS 클래스를 정의한 파일을 import하세요.

AudioPlayer _audioPlayer = AudioPlayer();
TTS tts = TTS();

class c_7_congratuations_left extends StatefulWidget {
  const c_7_congratuations_left({super.key});

  @override
  State<c_7_congratuations_left> createState() => _c_7_congratuations_leftState();
}

class _c_7_congratuations_leftState extends State<c_7_congratuations_left> {

  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await _audioPlayer.play(AssetSource("effect_ascending.mp3"));

    await tts.TextToSpeech("축하합니다. 모든 이야기를 마치셨습니다. 이번 경험을 바탕으로 실제로 편의점에 갔을 때 어떻게 행동해야 할지 잘 생각해보시기 바랍니다.",
        "ko-KR-Wavenet-D");

    await Future.delayed(Duration(seconds: 7));

  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20), // Container의 borderRadius와 동일하게 설정
      child: Text(
        "CLEAR!",
        style: TextStyle(fontSize: 40),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class c_7_congratuations_right extends StatefulWidget {
  const c_7_congratuations_right({super.key});

  @override
  State<c_7_congratuations_right> createState() => _c_7_congratuations_rightState();
}

class _c_7_congratuations_rightState extends State<c_7_congratuations_right> {
  String door_image = "assets/door_closed.png";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: (){},
            child: Text(
              "나가기",
              style: TextStyle(fontSize: 40),
              textAlign: TextAlign.center,
            ),
        ),
      )
    );
  }
}
