import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';
import '../StepData.dart';

import 'package:rive/rive.dart' hide Image;

final tts = TTS();

class Scenario_hurt_12_left extends StatefulWidget {
  final StatefulWidget acter;

  const Scenario_hurt_12_left({super.key, required this.acter});

  @override
  State<Scenario_hurt_12_left> createState() => _Scenario_hurt_12_leftState();
}

class _Scenario_hurt_12_leftState extends State<Scenario_hurt_12_left> {
  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await Future.delayed(Duration(milliseconds: 300));
    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "칼은 위험해서 부모님이 아니면 절대 만지면 안돼요. "
            "앞으로는 절대 칼을 만지지 말도록 해요. 잘 아시겠죠? "
            "그럼 오른쪽 화면의 다음으로 넘어가기 버튼을 눌러보세요! "
    );
    await tts.TextToSpeech(
            "칼은 위험해서 부모님이 아니면 절대 만지면 안돼요."
                "앞으로는 절대 칼을 만지지 말도록 해요. 잘 아시겠죠?"
                "그럼 오른쪽 화면의 다음으로 넘어가기 버튼을 눌러보세요! ",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;

    Provider.of<Scenario_Manager>(context, listen: false).increment_flag();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image(
              image: AssetImage("assets/hurt/칼피함.webp"),
              fit: BoxFit.cover, // 이미지가 Container에 꽉 차도록 설정
            ),
          ),
          Positioned.fill(child: widget.acter),
        ],
      ),
    );
  }
}

class Scenario_hurt_12_right extends StatefulWidget {
  final StepData step_data;

  const Scenario_hurt_12_right({super.key, required this.step_data});

  @override
  State<Scenario_hurt_12_right> createState() => _Scenario_hurt_12_rightState();
}

class _Scenario_hurt_12_rightState extends State<Scenario_hurt_12_right> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(children: [
          Provider.of<Scenario_Manager>(context, listen: false).flag == 1
              ? ElevatedButton(
              onPressed: () async {
                widget.step_data.sendStepData(
                    "hurt 12",
                    "(칼을 만지지 않도록 이용자에게 설명하는 상황)오른쪽 화면의 버튼을 손가락으로 직접 눌러보세요!",
                    "정답: 터치 완료",
                    "응답(터치하기): 터치 완료");
                await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
                    "참 잘했어요. "
                );
                await tts.TextToSpeech("참 잘했어요. ", "ko-KR-Wavenet-D");
                await tts.player.onPlayerComplete.first;
                tts.dispose();

                Provider.of<Scenario_Manager>(context, listen: false)
                    .decrement_flag();

                Provider.of<Scenario_Manager>(context, listen: false)
                    .updateIndex();
              },
              child: Text("다음으로 넘어가기!"))
              : const Text("먼저 설명을 들어보세요!"),
        ]),
      ),
    );
  }
}
