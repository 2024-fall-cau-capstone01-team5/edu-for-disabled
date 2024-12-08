import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import '../tts.dart'; // TTS 클래스를 정의한 파일을 import하세요.

import '../../providers/Scenario_Manager.dart';
import 'package:rive/rive.dart' hide Image;
import '../StepData.dart';

AudioPlayer _audioPlayer = AudioPlayer();
TTS tts = TTS();

class Scenario_park_8_left extends StatefulWidget {
  const Scenario_park_8_left({super.key});

  @override
  State<Scenario_park_8_left> createState() => _Scenario_park_8_leftState();
}

class _Scenario_park_8_leftState extends State<Scenario_park_8_left> {
  bool flag = false;

  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await Future.delayed(Duration(milliseconds: 300));
    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "즐겁게 놀았나요? 앞으론 산책을 나가거나 공원에 나갈 때 선생님과 부모님의 곁에서 떨어지지 말고 "
            "말씀을 잘 듣는 착한 사람이 돼보도록 해요"
    );
    await tts.TextToSpeech("즐겁게 놀았나요? "
        "앞으론 산책을 나가거나 공원에 나갈 때"
        "선생님과 부모님의 곁에서 떨어지지 말고"
        "말씀을 잘 듣는 착한 사람이 돼보도록 해요",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;

    setState(() {
      flag = true;
    });

    await _audioPlayer.play(AssetSource("effect_ascending.mp3"));
    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "축하합니다. 모든 이야기를 마치셨습니다. 이번 경험을 바탕으로 밖으로 놀러 갔을 때 어떻게 행동해야 할지 "
            "잘 생각해보시기 바랍니다."
    );
    await tts.TextToSpeech(
        "축하합니다. "
            "모든 이야기를 마치셨습니다. 이번 경험을 바탕으로 "
            "밖으로 놀러 갔을 때 어떻게 행동해야 할지 "
            "잘 생각해보시기 바랍니다.",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;
    tts.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      // Container의 borderRadius와 동일하게 설정
      child: flag == true
          ? RiveAnimation.asset(
              "assets/common/firework.riv",
              fit: BoxFit.contain,
            )
          : SizedBox.shrink(),
    );
  }
}

class Scenario_park_8_right extends StatefulWidget {
  final StepData step_data;

  const Scenario_park_8_right({super.key, required this.step_data});

  @override
  State<Scenario_park_8_right> createState() => _Scenario_park_8_rightState();
}

class _Scenario_park_8_rightState extends State<Scenario_park_8_right> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          "나가기",
          style: TextStyle(fontSize: 40),
          textAlign: TextAlign.center,

          //오디오 멈추는 작업 하기
        ),
      ),
    ));
  }
}
