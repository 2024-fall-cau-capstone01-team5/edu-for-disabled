import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';
import '../StepData.dart';

import 'package:rive/rive.dart' hide Image;

final tts = TTS();

class Scenario_hurt_11_left extends StatefulWidget {
  final StatefulWidget acter;

  const Scenario_hurt_11_left({super.key, required this.acter});

  @override
  State<Scenario_hurt_11_left> createState() => _Scenario_hurt_11_leftState();
}

class _Scenario_hurt_11_leftState extends State<Scenario_hurt_11_left> {
  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await Future.delayed(Duration(milliseconds: 300));
    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "구급 대원분들이 도착했네요. "
            "참 잘했어요. 구급 대원분들이 오실 때까지 침착하게 기다렸네요."
    );
    await tts.TextToSpeech(
        "구급 대원분들이 도착했네요. "
            "참 잘했어요. 구급 대원분들이 오실 때까지 침착하게 기다렸네요.",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;
    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "구급 대원분들이 도착하면 문을 열어주는 것을 잊으면 안돼요! 잘 아시겠죠? "
            "그럼, 오른쪽 화면의 다음으로 넘어가기 버튼을 손가락으로 직접 눌러보세요! "
    );
    await tts.TextToSpeech(
        "구급 대원분들이 도착하면 문을 열어주는 것을 잊으면 안돼요! 잘 아시겠죠? "
            "그럼, 오른쪽 화면의 다음으로 넘어가기 버튼을 손가락으로 직접 눌러보세요! ",
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
              image: AssetImage("assets/hurt/구급대원 도착.webp"),
              fit: BoxFit.cover, // 이미지가 Container에 꽉 차도록 설정
            ),
          ),
          Positioned.fill(child: widget.acter),
        ],
      ),
    );
  }
}

class Scenario_hurt_11_right extends StatefulWidget {
  final StepData step_data;

  const Scenario_hurt_11_right({super.key, required this.step_data});

  @override
  State<Scenario_hurt_11_right> createState() => _Scenario_hurt_11_rightState();
}

class _Scenario_hurt_11_rightState extends State<Scenario_hurt_11_right> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(children: [
          Provider.of<Scenario_Manager>(context, listen: false).flag == 1
              ? ElevatedButton(
                  onPressed: () async {
                    widget.step_data.sendStepData(
                        "hurt 11",
                        "(119 구급대원 분들이 도착한 상황)오른쪽 화면의 버튼을 손가락으로 직접 눌러보세요!",
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
