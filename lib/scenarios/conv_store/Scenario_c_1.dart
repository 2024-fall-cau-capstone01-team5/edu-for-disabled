import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';

import 'package:audioplayers/audioplayers.dart';
import '../tts.dart';

import 'package:rive/rive.dart' hide Image;

import '../StepData.dart';

final AudioPlayer _audioPlayer = AudioPlayer();
final TTS tts = TTS();

class c_1_enterTheStore_left extends StatefulWidget {
  final StatefulWidget acter;

  const c_1_enterTheStore_left({super.key, required this.acter});

  @override
  State<c_1_enterTheStore_left> createState() => _c_1_enterTheStore_leftState();
}

class _c_1_enterTheStore_leftState extends State<c_1_enterTheStore_left> {
  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await tts.TextToSpeech(
        "편의점에 도착했습니다. 저기 편의점 출입구가 보이네요. 오른쪽 화면에 나와있는 문을 터치해서 편의점에 들어가보세요.",
        "ko-KR-Wavenet-D");
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
                image: AssetImage("assets/c_outside.PNG"),
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

class c_1_enterTheStore_right extends StatefulWidget {
  final StepData step_data;
  const c_1_enterTheStore_right({super.key, required this.step_data});

  @override
  State<c_1_enterTheStore_right> createState() =>
      _c_1_enterTheStore_rightState();
}

class _c_1_enterTheStore_rightState extends State<c_1_enterTheStore_right> {
  SMITrigger? _touch;

  void _onRiveInit(Artboard artboard) {
    final controller =
        StateMachineController.fromArtboard(
            artboard,
            'State Machine 1',
          onStateChange: _onStateChange,

        );
    artboard.addController(controller!);

    _touch = controller.findInput<bool>('touch') as SMITrigger;
  }

  void _hitBump(){
    _touch?.fire();
    print("Touch TRIGGERED!!!!");
    


    //step_data.toJson();
    // json으로 return

  }

  void _onStateChange(String stateMachineName, String stateName) async{
    // 애니메이션이 끝나는 상태를 확인하여 print
    if (stateName == 'exit') {
      widget.step_data.sendStepData(
          "convenience 1",
          "(편의점에 들어가야 하는 상황)문을 터치하고 편의점에 들어가 보세요",
          "정답: 터치 완료",
          "응답(터치하기): 터치 완료"
      );

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
      child: RiveAnimation.asset(
        "assets/door_open.riv",
        fit: BoxFit.contain,

        onInit: _onRiveInit,
        stateMachines: const["State Machine 1"],
      ),
    ));
  }
}
