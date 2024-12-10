import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';

import 'package:audioplayers/audioplayers.dart';
import '../tts.dart';

import 'package:rive/rive.dart' hide Image;

import '../StepData.dart';

final AudioPlayer _audioPlayer = AudioPlayer();
final TTS tts = TTS();

class Scenario_c_6_left extends StatefulWidget {
  final StatefulWidget acter;

  const Scenario_c_6_left({super.key, required this.acter});

  @override
  State<Scenario_c_6_left> createState() => _Scenario_c_6_leftState();
}

class _Scenario_c_6_leftState extends State<Scenario_c_6_left> {
  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await tts.TextToSpeech(
        "그럼, 물건을 다 골랐으니 계산을 해볼까요? "
            "그런데 이런, 먼저 계산을 하러 온 손님이 있네요."
            "조금만 기다려볼까요? "
            "계산 줄을 차분하게 기다려 보도록 해요. "
            "편의점이나 가게에서 계산을 할 때에는 줄을 기다리는 경우가 많답니다. ",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;

    await tts.TextToSpeech(
            "이렇게 줄을 기다려야 할 때 나의 기분은 어떤가요?"
                "오른쪽 화면의 내가 느낀 기분을 손가락으로 직접 눌러보세요. ",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;

    Provider.of<Scenario_Manager>(context, listen: false).increment_flag();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20), // 부모의 경계 반경과 동일하게 설정
        child: Stack(
          children: [
            // 배경 이미지 (아래쪽에 위치)
            const Positioned.fill(
              child: Image(
                image: AssetImage("assets/convenience/편의점 줄.webp"),
                fit: BoxFit.cover, // 이미지가 Container에 맞도록 설정
              ),
            ),
            // 배우 이미지 (위쪽에 위치)
            Positioned.fill(
                child: widget.acter
            ),
          ],
        ),
      ),
    );
  }
}

class Scenario_c_6_right extends StatefulWidget {
  final StepData step_data;

  const Scenario_c_6_right({super.key, required this.step_data});

  @override
  State<Scenario_c_6_right> createState() =>
      _Scenario_c_6_rightState();
}

class _Scenario_c_6_rightState
    extends State<Scenario_c_6_right> {
  SMITrigger? _trigger1;
  SMITrigger? _trigger2;
  SMITrigger? _trigger3;
  SMIBool? _bool;

  void _onRiveInit(Artboard artboard) async {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
      onStateChange: _onStateChange,
    );

    if (controller != null) {
      artboard.addController(controller);
      _trigger1 = controller.findInput<SMITrigger>('Trigger 1') as SMITrigger?;
      _trigger2 = controller.findInput<bool>('Trigger 2') as SMITrigger?;
      _trigger3 = controller.findInput<SMITrigger>('Trigger 3') as SMITrigger?;
      _bool = controller.findInput<bool>('Boolean 1') as SMIBool?;
    }
  }

  void _onStateChange(String stateMachineName, String stateName) async {
    if (stateName == 'ExitState') {
      if (_bool?.value == true) {
        widget.step_data.sendStepData(
            "convenience 6",
            "(편의점 계산 줄을 기다릴 때 느끼는 감정을 선택하는 상황)오른쪽 화면의 자신의 기분을 선택해보세요.",
            "정답: 지루해요",
            "응답(감정 표현): 시간 초과");
      } else {
        widget.step_data.sendStepData(
            "missing_child 9",
            "(부모님과 재회했을 때 감정을 선택하는 상황)오른쪽 화면의 자신의 기분을 선택해보세요.",
            "정답: 지루해요",
            "응답(감정 표현): 지루해요");
      }

      await tts.TextToSpeech("참 잘했어요. ", "ko-KR-Wavenet-D");
      await tts.player.onPlayerComplete.first;
      tts.dispose();

      Provider.of<Scenario_Manager>(context, listen: false).decrement_flag();
      Provider.of<Scenario_Manager>(context, listen: false).updateIndex();
    } else if (stateName == "Timer exit") {
      _bool?.value = true;
      _trigger2?.value = true;
    } else if (stateName == "good") {
      await _audioPlayer.play(AssetSource("effect_incorrect.mp3"));

      widget.step_data.sendStepData(
          "missing_child 9",
          "(부모님과 재회했을 때 감정을 선택하는 상황)오른쪽 화면의 자신의 기분을 선택해보세요.",
          "정답: 지루해요",
          "응답(감정 표현): 슬퍼요");
    } else if (stateName == "angry") {
      await _audioPlayer.play(AssetSource("effect_incorrect.mp3"));

      widget.step_data.sendStepData(
          "missing_child 9",
          "(부모님과 재회했을 때 감정을 선택하는 상황)오른쪽 화면의 자신의 기분을 선택해보세요.",
          "정답: 지루해요",
          "응답(감정 표현): 화나요");
    } else if (stateName == "boring") {
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
            "assets/common/emotion_boring.riv",
            fit: BoxFit.contain,
            onInit: _onRiveInit,
          )
              : const Text("먼저 설명을 들어보세요!"),
        ]),
      ),
    );
  }
}

