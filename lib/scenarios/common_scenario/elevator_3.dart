import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';
import '../StepData.dart';

import 'package:rive/rive.dart' hide Image;

final tts = TTS();

class Elevator_3_left extends StatefulWidget {
  const Elevator_3_left({super.key});

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
    await tts.TextToSpeech("우리는 지금 몇 층으로 가야 하나요?"
        "올바른 층의 버튼을 터치해 보세요!", "ko-KR-Wavenet-D");
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      // Container의 borderRadius와 동일하게 설정
      child: const Image(
        image: AssetImage("assets/common/elevator_inside.png"),
        fit: BoxFit.cover, // 이미지가 Container에 꽉 차도록 설정
      ),
    );
  }
}

class Elevator_3_right extends StatefulWidget {
  const Elevator_3_right({super.key});

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
    StepData step_data = StepData(
        sceneId: "외출 common_scenario 4",
        question: "(1층으로 가야 하는 상황) 가야 하는 층의 엘리베이터 버튼을 눌러보세요",
        answer: "버튼 호출: 1층"
    );
    // step_data.toJson();
    print("Touch TRIGGERED!");
  }

  void _onStateChange(String stateMachineName, String stateName) {
    if (stateName == 'exit') {
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
          ElevatedButton(
              onPressed: (){
                Provider.of<Scenario_Manager>(context,listen: false).updateIndex();
              },
              child: Text("강제 화면 넘기기")
          )
        ]),
      ),
    );
  }
}
