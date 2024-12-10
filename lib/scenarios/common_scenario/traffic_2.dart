import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';

import '../tts.dart';

import 'package:rive/rive.dart' hide Image;
import '../StepData.dart';

final TTS tts = TTS();

class Traffic_2_left extends StatefulWidget {
  final StatefulWidget acter;

  const Traffic_2_left({super.key, required this.acter});

  @override
  State<Traffic_2_left> createState() => _Traffic_2_leftState();
}

class _Traffic_2_leftState extends State<Traffic_2_left> {
  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await tts.TextToSpeech(
        "자 그럼 횡단보도를 건너볼까요? "
            "오른쪽 화면을 손가락으로 직접 눌러보세요!",
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
                image: AssetImage("assets/common/traffic.png"),
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

class Traffic_2_right extends StatefulWidget {
  final StepData step_data;

  const Traffic_2_right({super.key, required this.step_data});

  @override
  State<Traffic_2_right> createState() => _Traffic_2_rightState();
}

class _Traffic_2_rightState extends State<Traffic_2_right> {
  SMITrigger? _touch;
  SMIBool? _bool;

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
      onStateChange: _onStateChange,
    );
    artboard.addController(controller!);

    _touch = controller.findInput<bool>('Trigger 1') as SMITrigger;
    _bool = controller.findInput<bool>('Boolean 1') as SMIBool;
  }

  void _onStateChange(String stateMachineName, String stateName) async {
    // 애니메이션이 끝나는 상태를 확인하여 print
    if (stateName == 'Animation 1') {
      if (_bool?.value == true) {
        widget.step_data.sendStepData(
            "traffic 2",
            "(횡단보도를 건너는 상황)오른쪽 화면을 손가락으로 눌러보세요!",
            "정답: 터치 완료",
            "응답(선택하기): 시간 초과");
      } else {
        widget.step_data.sendStepData(
            "traffic 2",
            "(횡단보도를 건너는 상황)오른쪽 화면을 손가락으로 눌러보세요!",
            "정답: 터치 완료",
            "응답(선택하기): 터치 완료");
      }

      await Provider.of<Scenario_Manager>(context, listen: false)
          .updateSubtitle(
          "잘 하셨습니다! 앞으로 횡단 보도를 건널 때에는 자동차가 확실하게 안 오는지 왼쪽 오른쪽을 잘 살펴주세요!");
      await tts.TextToSpeech(
          "잘 하셨습니다! "
              "앞으로 횡단 보도를 건널 때에는 자동차가 확실하게 안 오는지 왼쪽 오른쪽을 잘 살펴주세요!",
          "ko-KR-Wavenet-D");
      await tts.player.onPlayerComplete.first;

      tts.dispose();
      Provider.of<Scenario_Manager>(context, listen: false).decrement_flag();
      Provider.of<Scenario_Manager>(context, listen: false).updateIndex();
      print("EXIT");
    } else if (stateName == 'Timer exit') {
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
                  "assets/common/crossing.riv",
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
