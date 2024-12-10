import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';
import '../StepData.dart';

import 'package:rive/rive.dart' hide Image;

final tts = TTS();

class Scenario_hurt_6_left extends StatefulWidget {
  final StatefulWidget acter;

  const Scenario_hurt_6_left({super.key, required this.acter});

  @override
  State<Scenario_hurt_6_left> createState() => _Scenario_hurt_6_leftState();
}

class _Scenario_hurt_6_leftState extends State<Scenario_hurt_6_left> {
  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await Future.delayed(Duration(milliseconds: 300));
    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "만약에, 크게 다쳐서 피가 철철난다면 어떻게 해야 할까요? "
    );
    await tts.TextToSpeech(
            "만약에, 크게 다쳐서 피가 철철난다면 어떻게 해야 할까요? ",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;

    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "피가 철철난다면 연고를 바르고 반창고를 붙여도 상처에 소용이 없어요. "
    );
    await tts.TextToSpeech(
            "피가 철철난다면 연고를 바르고 반창고를 붙여도 상처에 소용이 없어요. ",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;

    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "이럴 땐 먼저, 상처가 난 곳을 수건으로 꾹 눌러서 피를 막아야 해요. "
    );
    await tts.TextToSpeech(
            "이럴 땐 먼저, 상처가 난 곳을 수건으로 꾹 눌러서 피를 막아야 해요. ",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;

    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "오른쪽 화면의 수건을 손가락으로 직접 눌러 상처가 난 곳을 수건으로 꾹 눌러보세요! "
    );
    await tts.TextToSpeech(
        "오른쪽 화면의 수건을 손가락으로 직접 눌러 상처가 난 곳을 수건으로 꾹 눌러보세요! ",
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
              image: AssetImage("assets/hurt/손가락 다침.webp"),
              fit: BoxFit.cover, // 이미지가 Container에 꽉 차도록 설정
            ),
          ),
          Positioned.fill(child: widget.acter),
        ],
      ),
    );
  }
}

class Scenario_hurt_6_right extends StatefulWidget {
  final StepData step_data;
  const Scenario_hurt_6_right({super.key, required this.step_data});

  @override
  State<Scenario_hurt_6_right> createState() => _Scenario_hurt_6_rightState();
}

class _Scenario_hurt_6_rightState extends State<Scenario_hurt_6_right> {
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


    if (stateName == 'ExitState') {
      if(_bool?.value == true){
        widget.step_data.sendStepData(
            "hurt 6",
            "(피가 철철나는 상처일 때 수건으로 지혈을 하는 상황)오른쪽 화면의 수건을 손가락으로 직접 눌러보세요!",
            "정답: 터치 완료",
            "응답(터치하기): 시간 초과"
        );
      }else {
        widget.step_data.sendStepData(
            "hurt 6",
            "(피가 철철나는 상처일 때 수건으로 지혈을 하는 상황)오른쪽 화면의 수건을 손가락으로 직접 눌러보세요!",
            "정답: 터치 완료",
            "응답(터치하기): 터치 완료"
        );
      }

      await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
          "참 잘했어요. "
              "피가 철철나게 놔두면 정말로 위험할 수 있어요. "
              "혹시 이런 일이 일어나면 꼭 수건으로 상처를 누르는 것을 잊지 말아주세요! "
      );
      await tts.TextToSpeech(
          "참 잘했어요. "
              "피가 철철나게 놔두면 정말로 위험할 수 있어요. "
              "혹시 이런 일이 일어나면 꼭 수건으로 상처를 누르는 것을 잊지 말아주세요! ",
          "ko-KR-Wavenet-D");
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
            "assets/hurt/pressure.riv",
            fit: BoxFit.contain,
            onInit: _onRiveInit,
          )
              : Image(image: AssetImage("assets/AAC/AAC_피나요.png")),
        ]),
      ),
    );
  }
}
