import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';
import '../StepData.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:rive/rive.dart' hide Image;

final tts = TTS();
final AudioPlayer _audioPlayer = AudioPlayer();

class Scenario_missing_child_2_left extends StatefulWidget {
  final StatefulWidget acter;

  const Scenario_missing_child_2_left({super.key, required this.acter});

  @override
  State<Scenario_missing_child_2_left> createState() =>
      _Scenario_missing_child_2_leftState();
}

class _Scenario_missing_child_2_leftState
    extends State<Scenario_missing_child_2_left> {
  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await Future.delayed(Duration(milliseconds: 300));
    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "여러분은 지금 부모님과 함께 시내 길을 걷고 있어요.\n"
            "주변에는 맛있는 빵을 파는 곳도 있고, "
            "예쁜 옷을 파는 곳도 있네요. "
    );
    await tts.TextToSpeech(
        "여러분은 지금 부모님과 함께 시내 길을 걷고 있어요. "
            "주변에는 맛있는 빵을 파는 곳도 있고, "
            "예쁜 옷을 파는 곳도 있네요. ",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;

    Provider.of<Scenario_Manager>(context, listen: false).increment_flag2();

    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "그런데 이런! 여러분이 다른 곳에 한눈 팔린 사이 부모님이 없어져 버렸어요!"
    );
    await tts.TextToSpeech(
        "그런데 이런! 여러분이 다른 곳에 한눈 팔린 사이 부모님이 없어져 버렸어요! ",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;
    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
            "이럴 때 나의 기분은 어떤가요?\n"
            "오른쪽 화면의 자기가 느낀 기분을 손가락으로 직접 눌러보세요! "
    );
    await tts.TextToSpeech(
            "이럴 때 나의 기분은 어떤가요? "
            "오른쪽 화면의 자기가 느낀 기분을 손가락으로 직접 눌러보세요! ",
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
          Provider.of<Scenario_Manager>(context, listen: false).flag2 == 1
              ? Positioned.fill(
                  child: Image(
                    image: AssetImage("assets/missing_child/시내_부모missing.webp"),
                    fit: BoxFit.cover, // 이미지가 Container에 꽉 차도록 설정
                  ),
                )
              : Positioned.fill(
                  child: Image(
                    image: AssetImage("assets/missing_child/시내_부모.webp"),
                    fit: BoxFit.cover, // 이미지가 Container에 꽉 차도록 설정
                  ),
                ),
          Positioned.fill(child: widget.acter),
        ],
      ),
    );
  }
}

class Scenario_missing_child_2_right extends StatefulWidget {
  final StepData step_data;

  const Scenario_missing_child_2_right({super.key, required this.step_data});

  @override
  State<Scenario_missing_child_2_right> createState() =>
      _Scenario_missing_child_2_rightState();
}

class _Scenario_missing_child_2_rightState
    extends State<Scenario_missing_child_2_right> {
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
      if (_trigger2 == null) {
        debugPrint("Error: _trigger2 is not initialized. Check Rive input name.");
      } else {
        debugPrint("Success: _trigger2 initialized successfully.");
      }
    }
  }

  void _onStateChange(String stateMachineName, String stateName) async {
    if (stateName == 'ExitState') {
      if (_bool?.value == true) {
        widget.step_data.sendStepData(
            "missing_child 2",
            "(길을 잃었을 때 감정을 선택하는 상황)오른쪽 화면의 자신의 기분을 선택해보세요.",
            "정답: 슬퍼요",
            "응답(감정 표현): 시간 초과");
      } else {
        widget.step_data.sendStepData(
            "missing_child 2",
            "(길을 잃었을 때 감정을 선택하는 상황)오른쪽 화면의 자신의 기분을 선택해보세요.",
            "정답: 슬퍼요",
            "응답(감정 표현): 슬퍼요");
      }

      await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
          "참 잘했어요. "
      );
      await tts.TextToSpeech("참 잘했어요. ", "ko-KR-Wavenet-D");
      await tts.player.onPlayerComplete.first;
      tts.dispose();

      Provider.of<Scenario_Manager>(context, listen: false).increment_flag2();
      Provider.of<Scenario_Manager>(context, listen: false).decrement_flag();
      Provider.of<Scenario_Manager>(context, listen: false).updateIndex();
    } else if (stateName == "Timer exit") {
      print("Timer exit!");
      _bool?.value = true;
      print("${_trigger2?.value}");
      _trigger2?.value = true;
      print("${_trigger2?.value}");

    } else if (stateName == "good") {
      await _audioPlayer.play(AssetSource("effect_incorrect.mp3"));

      widget.step_data.sendStepData(
          "missing_child 2",
          "(길을 잃었을 때 감정을 선택하는 상황)오른쪽 화면의 자신의 기분을 선택해보세요.",
          "정답: 슬퍼요",
          "응답(감정 표현): 좋아요");
    } else if (stateName == "angry") {
      await _audioPlayer.play(AssetSource("effect_incorrect.mp3"));

      widget.step_data.sendStepData(
          "missing_child 2",
          "(길을 잃었을 때 감정을 선택하는 상황)오른쪽 화면의 자신의 기분을 선택해보세요.",
          "정답: 슬퍼요",
          "응답(감정 표현): 화나요");
    } else if (stateName == "sad") {
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
                  "assets/common/emotion_sad.riv",
                  fit: BoxFit.contain,
                  onInit: _onRiveInit,
                )
              : const Text("먼저 설명을 들어보세요!"),
        ]),
      ),
    );
  }
}
