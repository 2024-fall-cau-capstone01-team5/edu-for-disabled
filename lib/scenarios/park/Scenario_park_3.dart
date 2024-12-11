import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';

import 'package:rive/rive.dart' hide Image;
import '../StepData.dart';

final tts = TTS();

class Scenario_park_3_left extends StatefulWidget {
  final StatefulWidget acter;

  const Scenario_park_3_left({super.key, required this.acter});

  @override
  State<Scenario_park_3_left> createState() => _Scenario_park_3_leftState();
}

class _Scenario_park_3_leftState extends State<Scenario_park_3_left> {
  @override
  void initState()  {
    super.initState();
     _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await Future.delayed(Duration(milliseconds: 300));
    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "그럼 출발해볼까요?"
    );
    await tts.TextToSpeech(
        "그럼 출발해볼까요?",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;
    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "오른쪽 화면의 자동차를 손가락으로 직접 눌러보세요!"
    );
    await tts.TextToSpeech(
        "오른쪽 화면의 자동차를 손가락으로 직접 눌러보세요!",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;

    Provider.of<Scenario_Manager>(context, listen: false).increment_flag();
  }



  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      // Container의 borderRadius와 동일하게 설정
      // child: const Image(
      //   image: AssetImage("assets/park/car.webp"),
      //   fit: BoxFit.contain, // 이미지가 Container에 꽉 차도록 설정
      // ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image(
              image: AssetImage("assets/park/car.webp"),
              fit: BoxFit.cover, // 이미지가 Container에 꽉 차도록 설정
            ),
          ),
          Positioned.fill(
              child: widget.acter
          ),
        ],
      ),
    );
  }
}

class Scenario_park_3_right extends StatefulWidget {
  final StepData step_data;

  const Scenario_park_3_right({super.key, required this.step_data});

  @override
  State<Scenario_park_3_right> createState() => _Scenario_park_3_rightState();
}

class _Scenario_park_3_rightState extends State<Scenario_park_3_right> {
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
            "park 3",
            "(자동차가 출발하는 상황)오른쪽 화면의 자동차를 손가락으로 직접 눌러보세요!",
            "정답: 터치 완료",
            "응답(터치하기): 시간 초과"
        );

      }else {
        widget.step_data.sendStepData(
            "park 3",
            "(자동차가 출발하는 상황)오른쪽 화면의 자동차를 손가락으로 직접 눌러보세요!",
            "정답: 터치 완료",
            "응답(터치하기): 터치 완료"
        );

      }



      await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle("참 잘했어요.");
      await tts.TextToSpeech("참 잘했어요. ", "ko-KR-Wavenet-D");
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
                  "assets/park/car_moving.riv",
                  fit: BoxFit.contain,
                  onInit: _onRiveInit,
                )
              : const SizedBox.shrink(),
        ]),
      ),
    );
  }
}
