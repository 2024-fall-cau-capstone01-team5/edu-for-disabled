import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:rive/rive.dart' hide Image;
import '../StepData.dart';

final tts = TTS();
final AudioPlayer _audioPlayer = AudioPlayer();

class Elevator_1_left extends StatefulWidget {
  final StatefulWidget acter;

  const Elevator_1_left({super.key, required this.acter});

  @override
  State<Elevator_1_left> createState() => _Elevator_1_leftState();
}

class _Elevator_1_leftState extends State<Elevator_1_left> {
  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await Future.delayed(Duration(milliseconds: 300));
    await Provider.of<Scenario_Manager>(context, listen: false)
        .updateSubtitle("여러분은 엘리베이터에 도착했어요.");
    await tts.TextToSpeech("여러분은 엘리베이터에 도착했어요.", "ko-KR-Wavenet-D");

    await tts.player.onPlayerComplete.first;

    await Provider.of<Scenario_Manager>(context, listen: false)
        .updateSubtitle("우리는 지금 아래로 내려가야 할까요? 아니면 "
            "위로 올라가야 할까요?\n오른쪽 화면에서 올바른 "
            "엘리베이터 호출 버튼을 손가락으로 직접 눌러보세요.");
    await tts.TextToSpeech(
        "우리는 지금 아래로 내려가야 할까요? 아니면 "
            "위로 올라가야 할까요? 오른쪽 화면에서 올바른 "
            "엘리베이터 호출 버튼을 손가락으로 직접 눌러보세요.",
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
                image: AssetImage("assets/common/엘리베이터 외부.webp"),
                fit: BoxFit.cover, // 이미지가 Container에 맞도록 설정
              ),
            ),
            // 배우 이미지 (위쪽에 위치)
            Positioned.fill(child: widget.acter),
          ],
        ),
      ),
    );
  }
}

class Elevator_1_right extends StatefulWidget {
  final StepData step_data;

  const Elevator_1_right({super.key, required this.step_data});

  @override
  State<Elevator_1_right> createState() => _Elevator_1_rightState();
}

class _Elevator_1_rightState extends State<Elevator_1_right> {
  SMITrigger? _touch_down;
  SMITrigger? _touch_up;
  SMIBool? _bool;

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
      onStateChange: _onStateChange,
    );

    if (controller != null) {
      artboard.addController(controller);
      _touch_down = controller.findInput<bool>('Trigger 1') as SMITrigger?;
      _touch_up = controller.findInput<SMITrigger>('Trigger 2') as SMITrigger?;
      _bool = controller.findInput<bool>('Boolean 1') as SMIBool?;
    }
  }

  void _onStateChange(String stateMachineName, String stateName) async {
    if (stateName == 'ExitState') {
      await _audioPlayer.play(AssetSource("effect_coorect.mp3"));
      await Future.delayed(Duration(seconds: 2));
      _audioPlayer.dispose();
      if (_bool?.value == true) {
        widget.step_data.sendStepData(
            "elevator 1",
            "(아래층으로 내려가기 위해 엘리베이터 호출 버튼을 누르는 상황)올바른 엘리베이터 호출 버튼을 눌러보세요!",
            "정답: 아래 방향 호출 버튼",
            "응답(선택하기): 시간 초과");
      } else {
        widget.step_data.sendStepData(
            "elevator 1",
            "(아래층으로 내려가기 위해 엘리베이터 호출 버튼을 누르는 상황)올바른 엘리베이터 호출 버튼을 눌러보세요!",
            "정답: 아래 방향 호출 버튼",
            "응답(선택하기): 아래 방향 호출 버튼");
      }

      await Provider.of<Scenario_Manager>(context, listen: false)
          .updateSubtitle("참 잘했어요. ");
      await tts.TextToSpeech("참 잘했어요. ", "ko-KR-Wavenet-D");
      await tts.player.onPlayerComplete.first;
      tts.dispose();
      Provider.of<Scenario_Manager>(context, listen: false).decrement_flag();
      Provider.of<Scenario_Manager>(context, listen: false).updateIndex();
    } else if (stateName == 'up') {
      await _audioPlayer.play(AssetSource("effect_incorrect.mp3"));

      widget.step_data.sendStepData(
          "elevator 1",
          "(1층으로 내려가기 위해 엘리베이터 호출 버튼을 누르는 상황)올바른 엘리베이터 호출 버튼을 눌러보세요!",
          "정답: 아래 방향 호출 버튼",
          "응답(선택하기): 위 방향 호출 버튼");
    } else if (stateName == "Timer exit") {
      _bool?.value = true;
      if (_touch_down?.value == false) {
        _touch_down?.value = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(children: [
          Provider.of<Scenario_Manager>(context, listen: false).flag == 1
              ? RiveAnimation.asset(
                  "assets/common/elevator_down_button.riv",
                  fit: BoxFit.contain,
                  onInit: _onRiveInit,
                )
              : const Text(
                  "먼저 설명을 들어보세요!",
                  style: TextStyle(fontSize: 15),
                ),
        ]),
      ),
    );
  }
}
