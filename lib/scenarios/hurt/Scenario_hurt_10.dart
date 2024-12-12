import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';
import '../StepData.dart';

import 'package:rive/rive.dart' hide Image;

final tts = TTS();

class Scenario_hurt_10_left extends StatefulWidget {
  final StatefulWidget acter;

  const Scenario_hurt_10_left({super.key, required this.acter});

  @override
  State<Scenario_hurt_10_left> createState() => _Scenario_hurt_10_leftState();
}

class _Scenario_hurt_10_leftState extends State<Scenario_hurt_10_left> {
  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await Future.delayed(Duration(milliseconds: 300));
    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "네. 지금 구급대원들이 출동했습니다.\n"
            "침착하게 기다려 주세요. "
            "그리고 전화는 끊지 마세요. "
    );
    await tts.TextToSpeech(
        "네. 지금 구급대원들이 출동했습니다. "
            "침착하게 기다려 주세요. "
            "그리고 전화는 끊지 마세요. ",
        "ko-KR-Wavenet-A");
    await tts.player.onPlayerComplete.first;

    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "구급 대원분들이 출동했다고 하네요. "
            "도착할 때까지 시간이 걸리니까\n침착하게 전화를 끊지 말고 끝까지 말을 잘 들어야 해요. 아시겠죠? "
    );
    await tts.TextToSpeech(
        "구급 대원분들이 출동했다고 하네요. "
            "도착할 때까지 시간이 걸리니까 침착하게 전화를 끊지 말고 끝까지 말을 잘 들어야 해요. 아시겠죠? ",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;
    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "만약 긴장이 된다면 크게 심호흡을 해 보도록 해요.\n"
            "오른쪽 화면의 버튼을 손가락으로 직접 눌러보세요. "
    );
    await tts.TextToSpeech(
        "만약 긴장이 된다면 크게 심호흡을 해 보도록 해요. "
            "오른쪽 화면의 버튼을 손가락으로 직접 눌러보세요. ",
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
              image: AssetImage("assets/hurt/call119.webp"),
              fit: BoxFit.cover, // 이미지가 Container에 꽉 차도록 설정
            ),
          ),
          Positioned.fill(child: widget.acter),
        ],
      ),
    );
  }
}

class Scenario_hurt_10_right extends StatefulWidget {
  final StepData step_data;

  const Scenario_hurt_10_right({super.key, required this.step_data});

  @override
  State<Scenario_hurt_10_right> createState() => _Scenario_hurt_10_rightState();
}

class _Scenario_hurt_10_rightState extends State<Scenario_hurt_10_right> {
  SMITrigger? _trigger;
  SMIBool? _bool;

  void _onRiveInit(Artboard artboard) async {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
      onStateChange: _onStateChange,
    );

    if (controller != null) {
      artboard.addController(controller);
      _trigger = controller.findInput<SMITrigger>('Trigger 1') as SMITrigger?;
      _bool = controller.findInput<bool>('Boolean 1') as SMIBool?;
    }
  }

  void _onStateChange(String stateMachineName, String stateName) async {
    if (stateName == 'BB') {
      if (_bool?.value == true) {
        widget.step_data.sendStepData(
            "hurt 10",
            "(119 구급대원 분들이 집에 도착할 때까지 심호흡을 하며 기다리는 상황)오른쪽 화면의 버튼을 손가락으로 직접 눌러보세요!",
            "정답: 터치 완료",
            "응답(터치하기): 시간 초과");
      } else {
        widget.step_data.sendStepData(
            "hurt 10",
            "(119 구급대원 분들이 집에 도착할 때까지 심호흡을 하며 기다리는 상황)오른쪽 화면의 버튼을 손가락으로 직접 눌러보세요!",
            "정답: 터치 완료",
            "응답(터치하기): 터치 완료");
      }

      await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
          "참 잘했어요. "
      );
      await tts.TextToSpeech("참 잘했어요. ", "ko-KR-Wavenet-D");
      await tts.player.onPlayerComplete.first;
      tts.dispose();
      Provider.of<Scenario_Manager>(context, listen: false).decrement_flag();

      Provider.of<Scenario_Manager>(context, listen: false).updateIndex();
    } else if (stateName == "Timer exit") {
      _bool?.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(children: [
          Provider.of<Scenario_Manager>(context, listen: false).flag == 1
              ? RiveAnimation.asset(
                  "assets/hurt/breath.riv",
                  fit: BoxFit.contain,
                  onInit: _onRiveInit,
                )
              : const Text("먼저 설명을 들어보세요!"),
        ]),
      ),
    );
  }
}
