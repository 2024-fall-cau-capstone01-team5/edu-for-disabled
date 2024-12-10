import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';

import 'package:audioplayers/audioplayers.dart';
import '../tts.dart';

import 'package:rive/rive.dart' hide Image;

import '../StepData.dart';

final AudioPlayer _audioPlayer = AudioPlayer();
final TTS tts = TTS();

class Scenario_c_8_left extends StatefulWidget {
  final StatefulWidget acter;

  const Scenario_c_8_left({super.key, required this.acter});

  @override
  State<Scenario_c_8_left> createState() => _Scenario_c_8_leftState();
}

class _Scenario_c_8_leftState extends State<Scenario_c_8_left> {
  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await tts.TextToSpeech(
        "이제 볼일을 다 봤으니 편의점에서 나가보도록 할까요? "
            "편의점에서 나가기 전에 챙기는 것을 잊어버린 물건은 없나요? "
            "혹시 모르니 앞으론 편의점을 나가기 전에 다시 한 번 꼼꼼히 확인해 보도록 해요. ",
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
                image: AssetImage("assets/convenience/편의점 나가기.webp"),
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

class Scenario_c_8_right extends StatefulWidget {
  final StepData step_data;
  const Scenario_c_8_right({super.key, required this.step_data});

  @override
  State<Scenario_c_8_right> createState() =>
      _Scenario_c_8_rightState();
}

class _Scenario_c_8_rightState extends State<Scenario_c_8_right> {
  SMITrigger? _touch;
  SMIBool? _bool;

  void _onRiveInit(Artboard artboard) {
    final controller =
    StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
      onStateChange: _onStateChange,

    );
    artboard.addController(controller!);

    _touch = controller.findInput<bool>('touch') as SMITrigger;
    _bool = controller.findInput<bool>('Boolean 1') as SMIBool;
  }

  void _onStateChange(String stateMachineName, String stateName) async{
    // 애니메이션이 끝나는 상태를 확인하여 print
    if (stateName == 'ExitState') {
      if (_bool?.value == true) {
        widget.step_data.sendStepData(
            "convenience 8",
            "(편의점을 나가는 상황)문을 터치해보세요!",
            "정답: 터치 완료",
            "응답(터치하기): 시간 초과"
        );
      } else {
        widget.step_data.sendStepData(
            "convenience 8",
            "(편의점을 나가는 상황)문을 터치해보세요!",
            "정답: 터치 완료",
            "응답(터치하기): 터치 완료"
        );
      }
      await tts.TextToSpeech(
          "잘하셨습니다. ",
          "ko-KR-Wavenet-D");
      await tts.player.onPlayerComplete.first;
      tts.dispose();

      Provider.of<Scenario_Manager>(context, listen: false).updateIndex();
      Provider.of<Scenario_Manager>(context, listen: false).decrement_flag();

    }else if (stateName == 'Timer exit'){
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
            "assets/common/door_opening_and_closing.riv",
            fit: BoxFit.contain,
            onInit: _onRiveInit,
          )
              : const Text("먼저 설명을 들어보세요!", style: TextStyle(fontSize: 15),),
        ]),
      ),
    );
  }
}
