import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:rive/rive.dart' hide Image;
import '../StepData.dart';

final tts = TTS();
final AudioPlayer _audioPlayer = AudioPlayer();

class Elevator_3_left extends StatefulWidget {
  final StatefulWidget acter;

  const Elevator_3_left({super.key, required this.acter});

  @override
  State<Elevator_3_left> createState() => _Elevator_3_leftState();
}

class _Elevator_3_leftState extends State<Elevator_3_left> {
  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await Future.delayed(Duration(milliseconds: 300));
    await Provider.of<Scenario_Manager>(context, listen: false)
        .updateSubtitle("여러분은 엘리베이터에 탔습니다. ");
    await tts.TextToSpeech(
        "여러분은 엘리베이터에 탔습니다. ",
        "ko-KR-Wavenet-D");

    await tts.player.onPlayerComplete.first;

    await Provider.of<Scenario_Manager>(context, listen: false)
        .updateSubtitle("여러분은 1층으로 내려가야 해요.");
    await tts.TextToSpeech("여러분은 1층으로 내려가야 해요.", "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;

    await Provider.of<Scenario_Manager>(context, listen: false)
        .updateSubtitle("오른쪽 화면에서 1층 버튼을 눌러보세요! ");
    await tts.TextToSpeech("오른쪽 화면에서 1층 버튼을 눌러보세요! ", "ko-KR-Wavenet-D");
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
                image: AssetImage("assets/common/엘리베이터 안.webp"),
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

class Elevator_3_right extends StatefulWidget {
  final StepData step_data;

  const Elevator_3_right({super.key, required this.step_data});

  @override
  State<Elevator_3_right> createState() => _Elevator_3_rightState();
}

class _Elevator_3_rightState extends State<Elevator_3_right> {
  SMITrigger? _trigger1;
  SMITrigger? _trigger2;
  SMITrigger? _trigger3;
  SMITrigger? _trigger4;
  SMIBool? _bool;

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
      onStateChange: _onStateChange,
    );

    if (controller != null) {
      artboard.addController(controller);
      _trigger1 = controller.findInput<bool>('Trigger 1') as SMITrigger?;
      _trigger2 = controller.findInput<SMITrigger>('Trigger 2') as SMITrigger?;
      _trigger3 = controller.findInput<SMITrigger>('Trigger 3') as SMITrigger?;
      _trigger4 = controller.findInput<SMITrigger>('Trigger 4') as SMITrigger?;
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
            "(1층으로 내려가기 위해 엘리베이터 버튼을 누르는 상황)올바른 엘리베이터 호출 버튼을 눌러보세요!",
            "정답: 1층",
            "응답(선택하기): 시간 초과");
      } else {
        widget.step_data.sendStepData(
            "elevator 1",
            "(1층으로 내려가기 위해 엘리베이터 버튼을 누르는 상황)올바른 엘리베이터 호출 버튼을 눌러보세요!",
            "정답: 1층",
            "응답(선택하기): 1층");
      }
      await Provider.of<Scenario_Manager>(context, listen: false)
          .updateSubtitle("참 잘했어요. ");
      await tts.TextToSpeech("참 잘했어요. ", "ko-KR-Wavenet-D");
      await tts.player.onPlayerComplete.first;
      tts.dispose();

      Provider.of<Scenario_Manager>(context, listen: false).decrement_flag();
      Provider.of<Scenario_Manager>(context, listen: false).updateIndex();
    }else if (stateName == 'Pressed 2') {
      await _audioPlayer.play(AssetSource("effect_incorrect.mp3"));
      widget.step_data.sendStepData(
          "elevator 1",
          "(1층으로 내려가기 위해 엘리베이터 버튼을 누르는 상황)올바른 엘리베이터 호출 버튼을 눌러보세요!",
          "정답: 1층",
          "응답(선택하기): 2층");
    } else if (stateName == 'Pressed 3') {
      await _audioPlayer.play(AssetSource("effect_incorrect.mp3"));
      widget.step_data.sendStepData(
          "elevator 1",
          "(1층으로 내려가기 위해 엘리베이터 버튼을 누르는 상황)올바른 엘리베이터 호출 버튼을 눌러보세요!",
          "정답: 1층",
          "응답(선택하기): 3층");
    } else if (stateName == 'Pressed 4') {
      await _audioPlayer.play(AssetSource("effect_incorrect.mp3"));
      widget.step_data.sendStepData(
          "elevator 1",
          "(1층으로 내려가기 위해 엘리베이터 버튼을 누르는 상황)올바른 엘리베이터 호출 버튼을 눌러보세요!",
          "정답: 1층",
          "응답(선택하기): 4층");
    } else if (stateName == "Timer exit") {
      _bool?.value = true;
      if(_trigger1?.value == false){
        _trigger1?.value = true;
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
                  "assets/common/elevator_number_button.riv",
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
