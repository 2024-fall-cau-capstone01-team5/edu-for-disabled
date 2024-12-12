import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import '../tts.dart'; // TTS 클래스를 정의한 파일을 import하세요.
import '../StepData.dart';

import '../../providers/Scenario_Manager.dart';
import 'package:rive/rive.dart' hide Image;

AudioPlayer _audioPlayer = AudioPlayer();
TTS tts = TTS();

class Scenario_ready_14_left extends StatefulWidget {
  const Scenario_ready_14_left({super.key});

  @override
  State<Scenario_ready_14_left> createState() => _Scenario_ready_14_leftState();
}

class _Scenario_ready_14_leftState extends State<Scenario_ready_14_left> {
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await Future.delayed(Duration(milliseconds: 300));
    await Provider.of<Scenario_Manager>(context, listen: false)
        .updateSubtitle("외출 준비를 해 보니까 어떤가요? 앞으로는 스스로 할 수 있는 것들은\n"
            "스스로 해 보는 착한 사람이 돼보도록 해요.");
    await tts.TextToSpeech(
        "외출 준비를 해 보니까 어떤가요? 앞으로는 스스로 할 수 있는 것들은 "
            "스스로 해 보는 착한 사람이 돼보도록 해요.",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;

    Provider.of<Scenario_Manager>(context, listen: false).increment_flag();

    await _audioPlayer.play(AssetSource("effect_ascending.mp3"));

    await Provider.of<Scenario_Manager>(context, listen: false)
        .updateSubtitle("축하합니다. 모든 이야기를 마치셨습니다. 이번 경험을 바탕으로\n"
            "집에 있을 때 어떻게 행동해야 할지 잘 생각해보시기 바랍니다.");
    await tts.TextToSpeech(
        "축하합니다. 모든 이야기를 마치셨습니다. 이번 경험을 바탕으로 "
            "집에 있을 때 어떻게 행동해야 할지 잘 생각해보시기 바랍니다.",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;
    tts.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        // Container의 borderRadius와 동일하게 설정
        child: RiveAnimation.asset(
          "assets/common/firework.riv",
          fit: BoxFit.contain,
        ));
  }
}

class Scenario_ready_14_right extends StatefulWidget {
  final StepData step_data;

  const Scenario_ready_14_right({super.key, required this.step_data});

  @override
  State<Scenario_ready_14_right> createState() =>
      _Scenario_ready_14_rightState();
}

class _Scenario_ready_14_rightState extends State<Scenario_ready_14_right> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child:
                Provider.of<Scenario_Manager>(context, listen: false).flag == 1
                    ? ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "나가기",
                          style: TextStyle(fontSize: 40),
                          textAlign: TextAlign.center,

                          //오디오 멈추는 작업 하기
                        ),
                      )
                    : const SizedBox.shrink()));
  }
}
