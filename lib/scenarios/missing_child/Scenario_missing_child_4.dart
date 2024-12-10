import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';
import '../StepData.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:rive/rive.dart' hide Image;

final tts = TTS();
final AudioPlayer _audioPlayer = AudioPlayer();

class Scenario_missing_child_4_left extends StatefulWidget {
  final StatefulWidget acter;

  const Scenario_missing_child_4_left({super.key, required this.acter});

  @override
  State<Scenario_missing_child_4_left> createState() =>
      _Scenario_missing_child_4_leftState();
}

class _Scenario_missing_child_4_leftState
    extends State<Scenario_missing_child_4_left> {
  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await Future.delayed(Duration(milliseconds: 300));
    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "길을 잃어서 어디로 가야할지 모를 때에는 사람들에게 도움을 구해야 해요. "
            "도움을 요청할 때에는 주변의 가게 직원 분께 도움을 요청해야 해요. "
    );
    await tts.TextToSpeech(
        "길을 잃어서 어디로 가야할지 모를 때에는 사람들에게 도움을 구해야 해요. "
            "도움을 요청할 때에는 주변의 가게 직원 분께 도움을 요청해야 해요. ",
            "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;
    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
            "낯선 사람에게 말을 거는 건 위험할 수 있어요. "
            "그러면 누구에게 도움을 요청해야 할 지 오른쪽 화면에서 손가락으로 직접 눌러보세요. "
    );
    await tts.TextToSpeech(
            "낯선 사람에게 말을 거는 건 위험할 수 있어요. "
            "그러면 누구에게 도움을 요청해야 할 지 오른쪽 화면에서 손가락으로 직접 눌러보세요. ",
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
              image: AssetImage("assets/missing_child/시내_부모missing.webp"),
              fit: BoxFit.cover, // 이미지가 Container에 꽉 차도록 설정
            ),
          ),
          Positioned.fill(child: widget.acter),
        ],
      ),
    );
  }
}

class Scenario_missing_child_4_right extends StatefulWidget {
  final StepData step_data;

  const Scenario_missing_child_4_right({super.key, required this.step_data});

  @override
  State<Scenario_missing_child_4_right> createState() =>
      _Scenario_missing_child_4_rightState();
}

class _Scenario_missing_child_4_rightState
    extends State<Scenario_missing_child_4_right> {
  SMITrigger? _trigger1;
  SMITrigger? _trigger2;
  SMIBool? _bool;

  void _onRiveInit(Artboard artboard) async {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
      onStateChange: _onStateChange,
    );

    if (controller != null) {
      artboard.addController(controller);
      _trigger1 = controller.findInput<bool>('Trigger 1') as SMITrigger?;
      _trigger2 = controller.findInput<bool>('Trigger 2') as SMITrigger?;
      _bool = controller.findInput<bool>('Boolean 1') as SMIBool?;
    }
  }

  void _onStateChange(String stateMachineName, String stateName) async {
    if (stateName == 'ExitState') {
      if (_bool?.value == true) {
        widget.step_data.sendStepData(
            "missing_child 4",
            "(길을 잃었을 때 지나가는 낯선 사람과, 가게 점원 중 누구에게 도움을 요청할지 선택하는 상황)누구에게 도움을 요청할지 선택해보세요.",
            "정답: 가게 점원",
            "응답(터치하기): 시간 초과");
      } else {
        widget.step_data.sendStepData(
            "missing_child 4",
            "(길을 잃었을 때 지나가는 낯선 사람과, 가게 점원 중 누구에게 도움을 요청할지 선택하는 상황)누구에게 도움을 요청할지 선택해보세요.",
            "정답: 가게 점원",
            "응답(터치하기): 가게 점원");
      }

      await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
          "참 잘했어요. "
              "앞으로 도움을 요청할 땐 모르는 낯선 사람에겐 함부로 다가가지 말도록 해요. "
      );
      await tts.TextToSpeech("참 잘했어요. "
          "앞으로 도움을 요청할 땐 모르는 낯선 사람에겐 함부로 다가가지 말도록 해요. ", "ko-KR-Wavenet-D");
      await tts.player.onPlayerComplete.first;
      tts.dispose();

      Provider.of<Scenario_Manager>(context, listen: false).decrement_flag();
      Provider.of<Scenario_Manager>(context, listen: false).updateIndex();
    } else if (stateName == "Timer exit") {
      _bool?.value = true;
      _trigger1?.value = true;
    } else if (stateName == "walker") {
      await _audioPlayer.play(AssetSource("effect_incorrect.mp3"));

      widget.step_data.sendStepData(
          "missing_child 4",
          "(길을 잃었을 때 지나가는 낯선 사람과, 가게 점원 중 누구에게 도움을 요청할지 선택하는 상황)누구에게 도움을 요청할지 선택해보세요.",
          "정답: 가게 점원",
          "응답(터치하기): 낯선 사람");
    } else if (stateName == "staff") {
      await _audioPlayer.play(AssetSource("effect_coorect.mp3"));
      await Future.delayed(Duration(seconds: 2));
      _audioPlayer.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(children: [
          Provider.of<Scenario_Manager>(context, listen: false).flag == 1
              ? RiveAnimation.asset(
                  "assets/missing_child/select_helper.riv",
                  fit: BoxFit.contain,
                  onInit: _onRiveInit,
                )
              : const Text("먼저 설명을 들어보세요!"),
        ]),
      ),
    );
  }
}
