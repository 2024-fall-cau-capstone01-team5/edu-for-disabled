import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';
import '../StepData.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:rive/rive.dart' hide Image;

final tts = TTS();
final AudioPlayer _audioPlayer = AudioPlayer();

class Scenario_hurt_2_left extends StatefulWidget {
  final StatefulWidget acter;

  const Scenario_hurt_2_left({super.key, required this.acter});

  @override
  State<Scenario_hurt_2_left> createState() =>
      _Scenario_hurt_2_leftState();
}

class _Scenario_hurt_2_leftState
    extends State<Scenario_hurt_2_left> {
  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await Future.delayed(Duration(milliseconds: 300));
    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "여러분은 지금 집에 있어요. 여러분은 주방으로 갔습니다.\n"
            "그런데 저기 부모님이 정리를 안하신 칼이 보이네요."
    );
    await tts.TextToSpeech(
        "여러분은 지금 집에 있어요. 여러분은 주방으로 갔습니다."
            "그런데 저기 부모님이 정리를 안하신 칼이 보이네요.",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;
    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "여러분은 호기심에 칼을 들어봅니다."
    );
    await tts.TextToSpeech(
        "여러분은 호기심에 칼을 들어봅니다.",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;

    Provider.of<Scenario_Manager>(context, listen: false).increment_flag2();
    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "그런데 이런, 칼이 손에서 미끄러지고 말았어요.\n"
            "여러분의 손가락에서 피가 나네요. "
    );
    await tts.TextToSpeech(
        "그런데 이런, 칼이 손에서 미끄러지고 말았어요. "
            "여러분의 손가락에서 피가 나네요. ",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;
    Provider.of<Scenario_Manager>(context, listen: false).increment_flag2();
    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "이런 상황일 때 여러분의 기분은 어떤가요?\n오른쪽 화면의 자기가 느낀 기분을 손가락으로 직접 눌러보세요."
    );
    await tts.TextToSpeech(
        "이런 상황일 때 여러분의 기분은 어떤가요? 오른쪽 화면의 자기가 느낀 기분을 손가락으로 직접 눌러보세요",
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
              image: AssetImage("assets/hurt/손가락 다침.webp"),
              fit: BoxFit.cover, // 이미지가 Container에 꽉 차도록 설정
            ),
          )
              : Positioned.fill(
            child: Image(
              image: AssetImage("assets/hurt/주방_식칼.webp"),
              fit: BoxFit.cover, // 이미지가 Container에 꽉 차도록 설정
            ),
          ),
          Positioned.fill(child: widget.acter),
        ],
      ),
    );
  }
}

class Scenario_hurt_2_right extends StatefulWidget {
  final StepData step_data;

  const Scenario_hurt_2_right({super.key, required this.step_data});

  @override
  State<Scenario_hurt_2_right> createState() =>
      _Scenario_hurt_2_rightState();
}

class _Scenario_hurt_2_rightState
    extends State<Scenario_hurt_2_right> {
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
            "hurt 2",
            "(손가락을 다쳤을 때 느낀 기분을 선택하는 상황)오른쪽 화면의 자신의 기분을 선택해보세요.",
            "정답: 아파요",
            "응답(감정 표현): 시간 초과");
      } else {
        widget.step_data.sendStepData(
            "hurt 2",
            "(손가락을 다쳤을 때 느낀 기분을 선택하는 상황)오른쪽 화면의 자신의 기분을 선택해보세요.",
            "정답: 아파요",
            "응답(감정 표현): 아파요");
      }

      await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
          "잘 하셨습니다. "
      );
      await tts.TextToSpeech(
          "잘 하셨습니다. ",
          "ko-KR-Wavenet-D");
      await tts.player.onPlayerComplete.first;
      tts.dispose();

      Provider.of<Scenario_Manager>(context, listen: false).increment_flag2();
      Provider.of<Scenario_Manager>(context, listen: false).decrement_flag();
      Provider.of<Scenario_Manager>(context, listen: false).updateIndex();
    } else if (stateName == "Timer exit") {
      _bool?.value = true;
      _trigger2?.value = true;

    } else if (stateName == "good") {
      await _audioPlayer.play(AssetSource("effect_incorrect.mp3"));

      widget.step_data.sendStepData(
          "hurt 2",
          "(손가락을 다쳤을 때 느낀 기분을 선택하는 상황)오른쪽 화면의 자신의 기분을 선택해보세요.",
          "정답: 아파요",
          "응답(감정 표현): 좋아요");
    } else if (stateName == "fun") {
      await _audioPlayer.play(AssetSource("effect_incorrect.mp3"));

      widget.step_data.sendStepData(
          "hurt 2",
          "(손가락을 다쳤을 때 느낀 기분을 선택하는 상황)오른쪽 화면의 자신의 기분을 선택해보세요.",
          "정답: 아파요",
          "응답(감정 표현): 즐거워요");
    } else if (stateName == "hurt") {
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
            "assets/common/emotion_hurt.riv",
            fit: BoxFit.contain,
            onInit: _onRiveInit,
          )
              : Image(image: AssetImage("assets/AAC/AAC_손가락피나요.png")),
        ]),
      ),
    );
  }
}
