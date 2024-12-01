import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';

import 'package:rive/rive.dart' hide Image;
import '../StepData.dart';

final tts = TTS();

class Elevator_1_left extends StatefulWidget {
  const Elevator_1_left({super.key});

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
    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "우리는 지금 아래로 내려가야 할까요? 아니면 "
            "위로 올라가야 할까요? 오른쪽 화면에 나오는 올바른 "
            "엘리베이터 호출 버튼을 눌러보세요."
    );
    await tts.TextToSpeech("우리는 지금 아래로 내려가야 할까요? 아니면 "
        "위로 올라가야 할까요? 오른쪽 화면에 나오는 올바른"
        "엘리베이터 호출 버튼을 눌러보세요", "ko-KR-Wavenet-D");
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      // Container의 borderRadius와 동일하게 설정
      child: const Image(
        image: AssetImage("assets/common/elevator.png"),
        fit: BoxFit.contain, // 이미지가 Container에 꽉 차도록 설정
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

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
      onStateChange: _onStateChange,
    );

    if (controller != null) {
      artboard.addController(controller);
      _touch_down =
          controller.findInput<SMITrigger>('touch_down') as SMITrigger?;
      _touch_up = controller.findInput<SMITrigger>('touch_up') as SMITrigger?;
    }
  }

  void _hitBumpDown() {
    _touch_down?.fire();
    widget.step_data.sendStepData(
        "외출 common_scenario 2",
        "(아래층으로 내려가야 하는 상황) 엘리베이터 호출 버튼을 눌러보세요",
        "호출: 아래 방향"
    );
    print('BUMPDOWN!');
    //step_data.toJson();
    //Json 변환

  }

  void _hitBumpUp() {
    _touch_up?.fire();
    widget.step_data.sendStepData(
        "외출 common_scenario 2",
        "(위층으로 올라가야 하는 상황)엘리베이터 호출 버튼을 눌러보세요",
        "호출: 위 방향"
    );
    //step_data.toJson();
  }

  void _onStateChange(String stateMachineName, String stateName) async{
    print("STATE CHANGED: $stateName");
    if (stateName == 'ExitState') {
      await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle("참 잘했어요. ");
      await tts.TextToSpeech(
          "참 잘했어요. ",
          "ko-KR-Wavenet-D");
      await tts.player.onPlayerComplete.first;
      Provider.of<Scenario_Manager>(context, listen: false).updateIndex();
      print("EXIT");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(children: [
          GestureDetector(
            onTapDown: (_) => _hitBumpDown(),
            onTapUp: (_) => _hitBumpUp(),
            child: RiveAnimation.asset(
              "assets/common/elevator_button.riv",
              fit: BoxFit.contain,
              onInit: _onRiveInit,
            ),
          ),
        ]),
      ),
    );
  }
}
