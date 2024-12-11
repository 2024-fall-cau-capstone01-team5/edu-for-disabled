import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';
import '../StepData.dart';

import 'package:rive/rive.dart' hide Image;

final tts = TTS();

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
    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "밖으로 나가려면 몇 층으로 가야 하나요?"
    );
    await tts.TextToSpeech(
        "밖으로 나가려면 몇 층으로 가야 하나요?",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "올바른 층의 버튼을 터치해 보세요!"
    );
    await tts.TextToSpeech(
        "올바른 층의 버튼을 터치해 보세요!",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;
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
                image: AssetImage("assets/common/elevator_inside.png"),
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

class Elevator_3_right extends StatefulWidget {
  final StepData step_data;
  const Elevator_3_right({super.key, required this.step_data});

  @override
  State<Elevator_3_right> createState() => _Elevator_3_rightState();
}

class _Elevator_3_rightState extends State<Elevator_3_right> {
  SMITrigger? _touch;

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
      onStateChange: _onStateChange,
    );

    if (controller != null) {
      artboard.addController(controller);
      _touch = controller.findInput<SMITrigger>('touch') as SMITrigger?;
    }
  }

  void _hitBump() {
    _touch?.fire();
    widget.step_data.sendStepData(
        "외출 common_scenario 4",
        "(1층으로 가야 하는 상황) 가야 하는 층의 엘리베이터 버튼을 눌러보세요",
        "정답: 1층",
        "응답: 1층"
    );
    // step_data.toJson();
    print("Touch TRIGGERED!");
  }

  void _onStateChange(String stateMachineName, String stateName) async{
    if (stateName == 'ExitState') {
      await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle("참 잘했어요.");
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
            onTap: _hitBump,
            child: RiveAnimation.asset(
              "assets/common/elevator_number_button.riv",
              fit: BoxFit.contain,
              onInit: _onRiveInit,
            ),
          ),

        ]),
      ),
    );
  }
}
