import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';

import 'package:audioplayers/audioplayers.dart';
import '../tts.dart';

import 'package:rive/rive.dart' hide Image;

import '../StepData.dart';

final AudioPlayer _audioPlayer = AudioPlayer();
final TTS tts = TTS();

class Scenario_c_7_left extends StatefulWidget {
  final StatefulWidget acter;

  const Scenario_c_7_left({super.key, required this.acter});

  @override
  State<Scenario_c_7_left> createState() => _Scenario_c_7_leftState();
}

class _Scenario_c_7_leftState extends State<Scenario_c_7_left> {
  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await tts.TextToSpeech(
        "다른 사람들이 계산을 다 마치고 드디어 여러분들의 차례가 왔네요."
            "계산을 해보도록 할까요? ",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;

    await _audioPlayer.play(AssetSource("effect_beep.mp3"));
    _audioPlayer.dispose();

    await tts.TextToSpeech(
        "천오백원입니다. 계산 도와드릴게요.",
        "ko-KR-Wavenet-A");
    await tts.player.onPlayerComplete.first;

    await tts.TextToSpeech(
            "오른쪽 화면의 카드를 손가락으로 직접 눌러 카드를 꽂아보세요! ",
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
                image: AssetImage("assets/convenience/편의점 카운터.webp"),
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

class Scenario_c_7_right extends StatefulWidget {
  final StepData step_data;
  const Scenario_c_7_right({super.key, required this.step_data});

  @override
  State<Scenario_c_7_right> createState() =>
      _Scenario_c_7_rightState();
}

class _Scenario_c_7_rightState extends State<Scenario_c_7_right> {
  SMITrigger? _trigger;
  SMIBool? _bool;

  void _onRiveInit(Artboard artboard) {
    final controller =
    StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
      onStateChange: _onStateChange,

    );
    artboard.addController(controller!);

    _trigger = controller.findInput<bool>('Trigger 1') as SMITrigger;
    _bool = controller.findInput<bool>('Boolean 1') as SMIBool;
  }

  void _onStateChange(String stateMachineName, String stateName) async{
    // 애니메이션이 끝나는 상태를 확인하여 print
    if (stateName == 'ExitState') {
      if (_bool?.value == true) {
        widget.step_data.sendStepData(
            "convenience 7",
            "(계산을 위해 카드를 카드 리더기에 꽂는 상황)카드를 터치해보세요!",
            "정답: 터치 완료",
            "응답(터치하기): 시간 초과"
        );
      } else {
        widget.step_data.sendStepData(
            "convenience 7",
            "(계산을 위해 카드를 카드 리더기에 꽂는 상황)카드를 터치해보세요!",
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
            "assets/convenience/POS Animation.riv",
            fit: BoxFit.contain,
            onInit: _onRiveInit,
          )
              : const Text("먼저 설명을 들어보세요!", style: TextStyle(fontSize: 15),),
        ]),
      ),
    );
  }
}
